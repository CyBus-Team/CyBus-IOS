import Foundation
import SwiftProtobuf

func downloadAndParseBinaryFile(from urlString: String) {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        guard let data = data else {
            print("No data")
            return
        }

        do {
            let feedMessage = try TransitRealtime_FeedMessage(serializedData: data)
            print("Parsed FeedMessage: \(feedMessage)")
            
            for entity in feedMessage.entity {
                if entity.hasTripUpdate {
                    print("Trip Update: \(entity.tripUpdate)")
                } else if entity.hasVehicle {
                    print("Vehicle Position: \(entity.vehicle)")
                }
            }
        } catch {
            print("Failed to parse data: \(error.localizedDescription)")
        }
    }

    task.resume()
}
