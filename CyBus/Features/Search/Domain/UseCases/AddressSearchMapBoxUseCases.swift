//
//  AddressSearchMapBoxUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import MapboxSearch

class AddressSearchMapBoxUseCases : AddressSearchUseCasesProtocol {
    
    private let repository: AddressSearchRepositoryProtocol
    
    init(repository: AddressSearchRepositoryProtocol = AddressSearchMapBoxRepository()) {
        self.repository = repository
    }
    
    func setup() throws {
        
    }
    
    func fetch<T>(query: String, completion: @escaping ([T]?) -> Void) throws {
        repository.fetch(query: query) { suggestions in
            if let suggestions = suggestions {
                print("Fetched suggestions: \(suggestions)")
            } else {
                print("No results or an error occurred.")
            }
        }
    }
    
    func select<T>(address: T) throws {
        <#code#>
    }
    
}
