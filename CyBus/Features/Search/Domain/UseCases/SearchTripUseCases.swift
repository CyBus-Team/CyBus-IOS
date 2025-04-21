//
//  SearchTripMapBoxUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 07/01/2025.
//

import Factory
import CoreLocation
import SwiftUI

class SearchTripUseCases: SearchTripUseCasesProtocol {
    
    @Injected(\.searchTripRepository) var repository: SearchTripRepositoryProtocol
    
    let lineColors: [Color] = [
        .red,
        .green,
        .orange,
        .purple,
        .pink,
        .yellow,
        .teal,
        .indigo,
        .mint
    ]
    
    func fetchTrips(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) async throws -> [SearchTripEntity] {
        do {
            let now = Date()
            let dto = try await repository.fetchTrips(from: from, to: to, date: now)
            let trips = dto.data.trip.tripPatterns.map { trip in
                SearchTripEntity(
                    id: UUID().uuidString,
                    duration: durationFromSeconds(trip.duration),
                    distance: trip.distance,
                    formattedDistance: formattedDistance(trip.distance),
                    startTime: dateFromISO8601String(trip.expectedStartTime),
                    endTime: dateFromISO8601String(trip.expectedEndTime),
                    legs: trip.legs.map { leg in
                        LegEntity(
                            id: UUID().uuidString,
                            points: decodePolyline(leg.pointsOnLink?.points ?? ""),
                            mode: legModeFrom(dto: leg.mode),
                            line: leg.line?.publicCode,
                            lineColor: getColor(of: leg.mode)
                        )
                    }
                )
            }
            return trips
        } catch {
            throw error
        }
    }
    
    func getColor(of mode: String) -> Color {
        let legMode = legModeFrom(dto: mode)
        return legMode == .foot ? .blue : lineColors.randomElement() ?? .blue
    }
    
    func dateFromISO8601String(_ isoString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: isoString)
    }
    
    func legModeFrom(dto value: String) -> LegMode {
        switch value {
        case "bus":
                .bus
        case "foot":
                .foot
        default:
                .unowned(value)
        }
    }
    
    func durationFromSeconds(_ seconds: Int) -> Duration {
        Duration.seconds(seconds)
    }
    
    func formattedDistance(_ distance: Double) -> String {
        if distance >= 1000 {
            let kilometers = distance / 1000
            return String(format: "%.1f km", kilometers)
        } else {
            return String(format: "%.0f m", distance)
        }
    }
    
    func decodePolyline(_ encoded: String) -> [CLLocationCoordinate2D] {
        guard !encoded.isEmpty else {
            return []
        }
        var coordinates: [CLLocationCoordinate2D] = []
        let characters = Array(encoded)
        var index = 0
        var lat = 0
        var lng = 0
        
        while index < characters.count {
            var result = 0
            var shift = 0
            var byte: Int
            
            repeat {
                byte = Int(characters[index].asciiValue!) - 63
                index += 1
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20
            
            let deltaLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1)
            lat += deltaLat
            
            result = 0
            shift = 0
            
            repeat {
                byte = Int(characters[index].asciiValue!) - 63
                index += 1
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20
            
            let deltaLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1)
            lng += deltaLng
            
            let finalLat = Double(lat) * 1e-5
            let finalLng = Double(lng) * 1e-5
            
            coordinates.append(CLLocationCoordinate2D(latitude: finalLat, longitude: finalLng))
        }
        
        return coordinates
    }
    
}
