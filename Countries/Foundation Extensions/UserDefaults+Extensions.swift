//
//  UserDefaults+Extensions.swift
//  Countries
//
//  Created by Alireza Asadi on 12/3/22.
//

import Foundation
import CountriesCore

extension UserDefaults {
    func value<Value: Codable>(forKey key: String) -> Value? {
        if let data = data(forKey: key) {
            return try? JSONDecoder().decode(Value.self, from: data)
        }

        return nil
    }

    func set<Value: Codable>(_ value: Value?, forKey key: String) {
        if let value, let data = try? JSONEncoder().encode(value) {
            setValue(data, forKey: key)
        } else {
            setNilValueForKey(key)
        }
    }
}

extension UserDefaults {
    var allCountries: [Country]? {
        get { value(forKey: "AllCountries") }
        set { set(newValue, forKey: "AllCountries") }
    }

    var selectedCountries: [Country]? {
        get { value(forKey: "SelectedCountries") }
        set { set(newValue, forKey: "SelectedCountries") }
    }
}
