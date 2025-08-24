//
//  Bus.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//
import CoreLocation
import Foundation

struct BusEntity: Identifiable, Equatable {
    let id: String
    let routeId: String
    let label: String
    let position: CLLocationCoordinate2D
    let timestamp: TimestampEntity
    let shortLabel: String

    struct TimestampEntity: Equatable {
        let low: Int
        let high: Int
        let unsigned: Bool
    }

    static func == (lhs: BusEntity, rhs: BusEntity) -> Bool {
        lhs.id == rhs.id
    }

    static func from(dto: BusDTO) -> BusEntity {
        return BusEntity(
            id: dto.vehicleId,
            routeId: dto.routeId,
            label: dto.label,
            position: CLLocationCoordinate2D(latitude: dto.latitude, longitude: dto.longitude),
            timestamp: TimestampEntity(
                low: dto.timestamp.low,
                high: dto.timestamp.high,
                unsigned: dto.timestamp.unsigned
            ),
            shortLabel: dto.shortLabel
        )
    }
}
