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
    
    func fetch(query: String) -> (AddressDTO) -> Void {
        placeAutocomplete.suggestions(for: query) { result in
            result.map{ $0 }
        }
    }
    
}
