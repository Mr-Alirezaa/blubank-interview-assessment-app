//
//  OrderedDictionary.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import Foundation

struct OrderedDictionary<Key: Hashable, Value>: RandomAccessCollection {
    typealias Element = (key: Key, value: Value)
    typealias Index = Int

    struct Keys: RandomAccessCollection, Hashable {
        typealias Index = OrderedDictionary<Key, Value>.Index
        typealias SubSequence = Slice<OrderedDictionary<Key, Value>.Keys>
        typealias Indices = Range<Index>
        typealias Element = Key

        private var _keys: Array<Key>

        var startIndex: OrderedDictionary<Key, Value>.Index { _keys.startIndex }
        var endIndex: OrderedDictionary<Key, Value>.Index { _keys.endIndex }

        fileprivate init(_keys: Array<Key>) {
            self._keys = _keys
        }

        subscript(position: OrderedDictionary<Key, Value>.Index) -> Key {
            _keys[position]
        }
    }

    struct Values: RandomAccessCollection {
        typealias Index = OrderedDictionary<Key, Value>.Index
        typealias SubSequence = Slice<OrderedDictionary<Key, Value>.Values>
        typealias Indices = Range<Index>
        typealias Element = Value

        private var _values: Array<Value>

        var startIndex: OrderedDictionary<Key, Value>.Index { _values.startIndex }
        var endIndex: OrderedDictionary<Key, Value>.Index { _values.endIndex }

        fileprivate init(_values: Array<Value>) {
            self._values = _values
        }

        subscript(position: OrderedDictionary<Key, Value>.Index) -> Value {
            _values[position]
        }
    }

    fileprivate var _dictionary: Dictionary<Key, Value>
    fileprivate var _array: Array<Key>

    var startIndex: Int { _array.startIndex }
    var endIndex: Int { _array.endIndex }

    var keys: Keys { Keys(_keys: _array) }
    var values: Values { Values(_values: _array.map { _dictionary[$0]! }) }

    init() {
        _dictionary = [:]
        _array = []
    }

    private init(dictionary: Dictionary<Key, Value>, array: Array<Key>) {
        self._dictionary = dictionary
        self._array = array
    }

    subscript(position: Int) -> (key: Key, value: Value) {
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

    subscript(key: Key) -> Value? {
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
    static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        lhs._array == rhs._array && lhs._dictionary == rhs._dictionary
    }
}

extension OrderedDictionary: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (Key, Value)...) {
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
    init<Key: Hashable, Value>(_ orderedDictionary: OrderedDictionary<Key, Value>) where Self.Element == OrderedDictionary<Key, Value>.Element {
        self = orderedDictionary.map { $0 }
    }
}

extension Dictionary {
    init(_ orderedDictionary: OrderedDictionary<Key, Value>) where Self.Element == OrderedDictionary<Key, Value>.Element {
        self = orderedDictionary._dictionary
    }
}
