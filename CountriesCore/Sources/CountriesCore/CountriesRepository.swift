//
//  File.swift
//  
//
//  Created by Alireza Asadi on 12/3/22.
//

import Foundation

public protocol CountryRepositoryProtocol {
    func all() async throws -> [Country]
}

public class CountryRepository: CountryRepositoryProtocol {
    public init() {}
    
    public func all() async throws -> [Country] {
        try await RequestGenerator(session: URLSession(configuration: .default)).data(for: AllCountriesRequest())
    }
}
