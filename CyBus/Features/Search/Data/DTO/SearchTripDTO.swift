//
//  SearchTripDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 20/04/2025.
//

import Foundation

struct TripResponseDTO: Codable {
    let data: TripDataDTO
}

struct TripDataDTO: Codable {
    let trip: TripPatternsDTO
}

struct TripPatternsDTO: Codable {
    let previousPageCursor: String?
    let nextPageCursor: String?
    let tripPatterns: [TripPatternDTO]
}

struct TripPatternDTO: Codable {
    let aimedStartTime: String
    let aimedEndTime: String
    let expectedEndTime: String
    let expectedStartTime: String
    let duration: Int
    let distance: Double
    let legs: [TripLegDTO]
    let systemNotices: [SystemNoticeDTO]
}

struct TripLegDTO: Codable {
    let id: String?
    let mode: String
    let aimedStartTime: String
    let aimedEndTime: String
    let expectedEndTime: String
    let expectedStartTime: String
    let realtime: Bool
    let distance: Double
    let duration: Int
    let fromPlace: PlaceDTO
    let toPlace: PlaceDTO
    let toEstimatedCall: EstimatedCallDTO?
    let line: LineDTO?
    let authority: AuthorityDTO?
    let pointsOnLink: PointsOnLinkDTO?
    let interchangeTo: InterchangeDTO?
    let interchangeFrom: InterchangeDTO?
}

struct PlaceDTO: Codable {
    let name: String
    let quay: QuayDTO?
}

struct QuayDTO: Codable {
    let id: String
}

struct EstimatedCallDTO: Codable {
    let destinationDisplay: DestinationDisplayDTO
}

struct DestinationDisplayDTO: Codable {
    let frontText: String
}

struct LineDTO: Codable {
    let publicCode: String
    let name: String
    let id: String
}

struct AuthorityDTO: Codable {
    let name: String
    let id: String
}

struct PointsOnLinkDTO: Codable {
    let points: String
}

struct InterchangeDTO: Codable {
    let staySeated: Bool
}

struct SystemNoticeDTO: Codable {
    let tag: String
}
