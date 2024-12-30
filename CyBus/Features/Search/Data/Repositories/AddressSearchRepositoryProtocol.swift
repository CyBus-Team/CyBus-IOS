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
    func fetch<T: Decodable>(query: String, completion: @escaping ([T]?) -> Void)
    func select<T>(suggestion: T) throws
}
