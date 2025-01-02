//
//  AddressSearchMapBoxRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//
import MapboxSearch

class AddressSearchMapBoxRepository: AddressSearchRepositoryProtocol {
    
    private let bundle: Bundle
    private var placeAutocomplete: PlaceAutocomplete?
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func setup() throws {
        if let mapBoxAccessToken = bundle.object(forInfoDictionaryKey: "MBXAccessToken") as? String {
            self.placeAutocomplete = PlaceAutocomplete(accessToken: mapBoxAccessToken)
        } else {
            throw AddressSearchRepositoryError.initializationFailed
        }
    }
    
    func select(suggestion: AddressEntity) throws {
        print("TODO")
    }
    
    func fetch(query: String, completion: @escaping ([AddressDTO]?) -> Void) {
        placeAutocomplete?.suggestions(for: query) { result in
            switch result {
            case .success(let suggestions):
                let result = suggestions.map { AddressDTO(id: $0.mapboxId, suggestion: $0) }
                completion(result)
            case .failure(let error):
                debugPrint("Error: \(error)")
                completion(nil)
            }
        }
    }
    
}
