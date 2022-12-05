//
//  OrderedDictionary.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import Foundation

public struct OrderedDictionary<Key: Hashable, Value>: RandomAccessCollection {
    public typealias Element = (key: Key, value: Value)
    public typealias Index = Int

    public struct Keys: RandomAccessCollection, Hashable {
        public typealias Index = OrderedDictionary<Key, Value>.Index
        public typealias SubSequence = Slice<OrderedDictionary<Key, Value>.Keys>
        public typealias Indices = Range<Index>
        public typealias Element = Key

        private var _keys: Array<Key>

        public var startIndex: OrderedDictionary<Key, Value>.Index { _keys.startIndex }
        public var endIndex: OrderedDictionary<Key, Value>.Index { _keys.endIndex }

        init(keys: Array<Key>) {
            self._keys = keys
        }

        public subscript(position: OrderedDictionary<Key, Value>.Index) -> Key {
            _keys[position]
        }
    }

    public struct Values: RandomAccessCollection {
        public typealias Index = OrderedDictionary<Key, Value>.Index
        public typealias SubSequence = Slice<OrderedDictionary<Key, Value>.Values>
        public typealias Indices = Range<Index>
        public typealias Element = Value

        private var _values: Array<Value>

        public var startIndex: OrderedDictionary<Key, Value>.Index { _values.startIndex }
        public var endIndex: OrderedDictionary<Key, Value>.Index { _values.endIndex }

        init(values: Array<Value>) {
            self._values = values
        }

        public subscript(position: OrderedDictionary<Key, Value>.Index) -> Value {
            _values[position]
        }
    }

    internal var _dictionary: Dictionary<Key, Value>
    internal var _array: Array<Key>

    public var startIndex: Int { _array.startIndex }
    public var endIndex: Int { _array.endIndex }

    public var keys: Keys { Keys(keys: _array) }
    public var values: Values { Values(values: _array.map { _dictionary[$0]! }) }

    init() {
        _dictionary = [:]
        _array = []
    }

    private init(dictionary: Dictionary<Key, Value>, array: Array<Key>) {
        self._dictionary = dictionary
        self._array = array
    }

    public subscript(position: Int) -> (key: Key, value: Value) {
        get {
            let key = _array[position]
            let value = _dictionary[key]!
            return (key, value)
        }
        set {
            _array[position] = newValue.key
            _dictionary[newValue.key] = newValue.value
        }
    }

    public subscript(key: Key) -> Value? {
        get {
            _dictionary[key]
        }
        set {
            if let newValue {
                if !_dictionary.keys.contains(key) {
                    _array.append(key)
                }
                _dictionary[key] = newValue
            } else {
                if _dictionary.keys.contains(key) {
                    _array.removeAll { $0 == key }
                }
                _dictionary[key] = nil
            }
        }
    }
}

extension OrderedDictionary: Equatable where Value: Equatable {
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs._array == rhs._array && lhs._dictionary == rhs._dictionary
    }
}

extension OrderedDictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        var dict: Dictionary<Key, Value> = [:]
        var arr: Array<Key> = []
        for (key, value) in elements {
            arr.append(key)
            dict[key] = value
        }
        self.init(dictionary: dict, array: arr)
    }
}

extension Array {
    public init<Key: Hashable, Value>(_ orderedDictionary: OrderedDictionary<Key, Value>) where Self.Element == OrderedDictionary<Key, Value>.Element {
        self = orderedDictionary.map { $0 }
    }
}

extension Dictionary {
    public init(_ orderedDictionary: OrderedDictionary<Key, Value>) where Self.Element == OrderedDictionary<Key, Value>.Element {
        self = orderedDictionary._dictionary
    }
}
