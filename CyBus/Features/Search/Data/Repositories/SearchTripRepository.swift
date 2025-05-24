//
//  SearchTripRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import Foundation
import FactoryKit
import CoreLocation

class SearchTripRepository: SearchTripRepositoryProtocol {
    
    private let urlSession: URLSession
    private var appConfiguration: AppConfiguration
    
    init(urlSession: URLSession = .shared, appConfiguration: AppConfiguration = Container.shared.appConfiguration()) {
        self.urlSession = urlSession
        self.appConfiguration = appConfiguration
    }
    
    func fetchTrips(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, date: Date) async throws -> TripResponseDTO {
        var request = URLRequest(url: appConfiguration.backendURL.appendingPathComponent("api/v2/otp/transmodel/v3"))
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // TODO: Add GraphQL client
        let body: [String: Any] = [
            "query": """
            query trip($from: Location!, $to : Location!, $arriveBy: Boolean, $dateTime: DateTime, $numTripPatterns: Int, $searchWindow: Int, $modes: Modes, $itineraryFiltersDebug: ItineraryFilterDebugProfile, $pageCursor: String) {
              trip(
                from: $from
                to: $to
                arriveBy: $arriveBy
                dateTime: $dateTime
                numTripPatterns: $numTripPatterns
                searchWindow: $searchWindow
                modes: $modes
                itineraryFilters: {debug: $itineraryFiltersDebug}
                pageCursor: $pageCursor
              ) {
                previousPageCursor
                nextPageCursor
                tripPatterns {
                  aimedStartTime
                  aimedEndTime
                  expectedEndTime
                  expectedStartTime
                  duration
                  distance
                  legs {
                    id
                    mode
                    aimedStartTime
                    aimedEndTime
                    expectedEndTime
                    expectedStartTime
                    realtime
                    distance
                    duration
                    fromPlace { name quay { id } }
                    toPlace { name quay { id } }
                    toEstimatedCall { destinationDisplay { frontText } }
                    line { publicCode name id }
                    authority { name id }
                    pointsOnLink { points }
                    interchangeTo { staySeated }
                    interchangeFrom { staySeated }
                  }
                  systemNotices { tag }
                }
              }
            }
            """,
            "variables": [
                "from": ["coordinates": ["latitude": from.latitude, "longitude": from.longitude]],
                "to": ["coordinates": ["latitude": to.latitude, "longitude": to.longitude]],
                "dateTime": ISO8601DateFormatter().string(from: date),
                "numTripPatterns": 4
            ],
            "operationName": "trip"
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let tripResponse = try decoder.decode(TripResponseDTO.self, from: data)
        return tripResponse
    }
    
}
