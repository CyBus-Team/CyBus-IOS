//
//  AddressSearchRepositoryProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

enum AddressSearchRepositoryError: Error {
    case initializationFailed
}

protocol AddressSearchRepositoryProtocol {
    func setup() throws
    func fetch(query: String, completion: @escaping ([AddressDTO]?) -> Void)
    func select(suggestion: AddressEntity) throws
}
