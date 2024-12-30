//
//  AddressSearchUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

protocol AddressSearchUseCasesProtocol {
    func setup() throws
    func fetch<T>(query: String, completion: @escaping ([T]?) -> Void) throws
    func select<T>(address: T) throws
}
