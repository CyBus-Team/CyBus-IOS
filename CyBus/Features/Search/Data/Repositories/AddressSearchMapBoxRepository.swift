//
//  AddressSearchMapBoxRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//
import MapboxSearch

class AddressSearchMapBoxRepository: AddressSearchRepositoryProtocol {
    
    public let suggestionCountry = Country(countryCode: "CY")
    
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
    
    func fetch(query: String, userLocation: CLLocationCoordinate2D) async throws -> [SuggestionDTO] {
        guard let placeSDK = placeAutocomplete, let cyprus = suggestionCountry else {
            throw AddressSearchRepositoryError.initializationFailed
        }
        return try await withCheckedThrowingContinuation { continuation in
            placeSDK.suggestions(for: query, proximity: userLocation, filterBy: .init(countries: [cyprus] )) { result in
                switch result {
                case .success(let suggestions):
                    let dtos = suggestions.map { SuggestionDTO(id: $0.mapboxId, suggestion: $0) }
                    continuation.resume(returning: dtos)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func select(suggestion: SuggestionEntity) async throws -> DetailedSuggestionDTO {
        guard let placeSDK = placeAutocomplete else {
            throw AddressSearchRepositoryError.initializationFailed
        }
        return try await withCheckedThrowingContinuation { continuation in
            placeSDK.select(suggestion: suggestion.suggestion) { result in
                switch result {
                case .success(let detailedSuggestion):
                    debugPrint("detailedSuggestion : \(detailedSuggestion)")
                    continuation.resume(returning: DetailedSuggestionDTO(id: detailedSuggestion.mapboxId, result: detailedSuggestion))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
