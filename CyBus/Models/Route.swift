import Foundation

// Define a structure to match the JSON data
struct Route: Codable {
    let lineID: String
    let lineName: String
    let routeName: String
    let firstStop: String
    let lastStop: String?
    let direction: String
    let lineLength: String
    
    enum CodingKeys: String, CodingKey {
        case lineID = "line_id"
        case lineName = "line_name"
        case routeName = "route_name"
        case firstStop = "first_stop"
        case lastStop = "last_stop"
        case direction
        case lineLength = "line_length"
    }
}
