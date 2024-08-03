import Foundation
import SwiftProtobuf
@_spi(Experimental) import MapboxMaps

class TransitAPIClient {
    static let shared = TransitAPIClient()
    
    // TODO: Setup env - (issue)[https://github.com/PopovVA/CyBus/issues/3]
    let urlString = "http://20.19.98.194:8328/Api/api/gtfs-realtime"
    
    // Function to load and decode JSON file
    func loadRoutes(from filename: String) -> [Route]? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename) in bundle.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let routes = try decoder.decode([Route].self, from: data)
            return routes
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchBuses(completion: @escaping (Result<[Bus], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        let routes = loadRoutes(from: "routes")

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                // TODO: Errors localization - (issue)[https://github.com/PopovVA/CyBus/issues/4]
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let feedMessage = try TransitRealtime_FeedMessage(serializedData: data)
                let buses = feedMessage.entity.compactMap { entity -> Bus? in
                    if !entity.hasVehicle {
                        return nil
                    }
                    if let route = routes?.first(where: { $0.lineID == entity.vehicle.trip.routeID }) {
                        let bus = Bus(
                            id: entity.vehicle.vehicle.id,
                            location: CLLocationCoordinate2D(
                                latitude: CLLocationDegrees(entity.vehicle.position.latitude),
                                longitude: CLLocationDegrees(entity.vehicle.position.longitude)
                            ),
                            route: route
                        )
                        return bus
                    } else {
                        return nil
                    }
                }
                completion(.success(buses.compactMap{$0}))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
}
