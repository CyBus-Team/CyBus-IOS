//
//  SearchTripDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 20/04/2025.
//

import Foundation

typealias TripResponseDTO = [TripPatternDTO]

struct TripPatternDTO: Codable {
    let aimedStartTime: String       // "2023-04-20T08:00:00+0000"
    let aimedEndTime: String         // "2023-04-20T09:00:00+0000"
    let expectedEndTime: String      // "2023-04-20T09:05:00+0000"
    let expectedStartTime: String    // "2023-04-20T08:02:00+0000"
    let duration: Int                // 3600
    let distance: Double             // 15000.5
    let legs: [TripLegDTO]           // Array of trip legs
    let systemNotices: [SystemNoticeDTO] // Notices related to the trip
    let generalizedCost: Int         // 1200
}

struct TripLegDTO: Codable {
    let id: String?                  // "leg123"
    let mode: String                 // "BUS"
    let aimedStartTime: String       // "2023-04-20T08:00:00+0000"
    let aimedEndTime: String         // "2023-04-20T08:30:00+0000"
    let expectedEndTime: String      // "2023-04-20T08:32:00+0000"
    let expectedStartTime: String    // "2023-04-20T08:01:00+0000"
    let realtime: Bool               // true
    let distance: Double             // 8000.0
    let duration: Int                // 1800
    let fromPlace: PlaceDTO          // Starting place
    let toPlace: PlaceDTO            // Ending place
    let toEstimatedCall: EstimatedCallDTO? // Estimated call info
    let line: LineDTO?               // Line information
    let authority: AuthorityDTO?     // Authority info
    let pointsOnLink: PointsOnLinkDTO? // Points on link
    let interchangeTo: InterchangeDTO? // Interchange info to
    let interchangeFrom: InterchangeDTO? // Interchange info from
    let generalizedCost: Int?       // 600
}

struct PlaceDTO: Codable {
    let name: String                 // "Central Station"
    let quay: QuayDTO?               // Quay information
}

struct QuayDTO: Codable {
    let id: String                   // "quay456"
}

struct EstimatedCallDTO: Codable {
    let destinationDisplay: DestinationDisplayDTO // Destination display info
}

struct DestinationDisplayDTO: Codable {
    let frontText: String            // "Downtown"
}

struct LineDTO: Codable {
    let publicCode: String           // "10A"
    let name: String                 // "Line 10A"
    let id: String                   // "line789"
    let presentation: String         // "Bus 10A"
}

struct AuthorityDTO: Codable {
    let name: String                 // "City Transport Authority"
    let id: String                   // "auth001"
}

struct PointsOnLinkDTO: Codable {
    let points: String               // "encodedPolylineString"
}

struct InterchangeDTO: Codable {
    let staySeated: Bool             // false
}

struct SystemNoticeDTO: Codable {
    let tag: String                 // "delay"
}
