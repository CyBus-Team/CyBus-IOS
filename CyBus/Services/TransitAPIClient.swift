import Foundation
import SwiftProtobuf

class TransitAPIClient {
    static let shared = TransitAPIClient()
    
    let urlString = "http://20.19.98.194:8328/Api/api/gtfs-realtime"
    
    func fetchBuses(completion: @escaping (Result<[Bus], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            // TODO: Localize the error message
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                // TODO: Localize the error message
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let feedMessage = try TransitRealtime_FeedMessage(serializedData: data)
                let buses = feedMessage.entity.compactMap { entity -> Bus? in
                    if !entity.hasVehicle {
                        return nil
                    }
                    let bus = Bus(
                        id: entity.id,
                        route: entity.tripUpdate.trip.routeID,
                        currentLocation: MapLocation(
                            latitude: entity.vehicle.position.latitude,
                            longitude: entity.vehicle.position.longitude
                        )
                    )
                    return bus
                }
                completion(.success(buses))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
}
