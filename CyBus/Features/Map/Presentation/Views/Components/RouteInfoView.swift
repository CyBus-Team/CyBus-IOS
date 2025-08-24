//
//  RouteInfoView.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import SwiftUI

struct RouteInfoView: View {
    @Environment(\.theme) var theme

    var routeName: String
    var routeNumber: String
    var departureTime: String
    var arrivalTime: String
    var action: () -> Void
    
    init(
        routeName: String,
        routeNumber: String,
        departureTime: String,
        arrivalTime: String,
        action: @escaping () -> Void,
    ) {
        self.routeName = routeName
        self.routeNumber = routeNumber
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.action = action
    }

    var body: some View {
        HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(routeNumber.isEmpty ? "—" : routeNumber)
                            .font(.headline)
                            .bold()
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .background(theme.colors.primary.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                        Text(routeName.isEmpty ? "Route" : routeName)
                            .font(.subheadline)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    HStack(spacing: 8) {
                        Label(departureTime.isEmpty ? "—" : departureTime, systemImage: "clock")
                            .font(.caption)
                        Image(systemName: "arrow.right")
                            .font(.caption)
                        Label(arrivalTime.isEmpty ? "—" : arrivalTime, systemImage: "flag.checkered")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            // Close button
            Button(action: action) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(theme.colors.primary)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(radius: 8)
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 16) {
        RouteInfoView(
            routeName: "Nightly Oroklini - Pyla - C.T.O  - Makenzy - Larnaca Station",
            routeNumber: "445",
            departureTime: "00:15",
            arrivalTime: "04:00",
            action: { print("Clear") },
        )
        RouteInfoView(
            routeName: "Nightly Oroklini - Pyla - C.T.O  - Makenzy - Larnaca Station",
            routeNumber: "445",
            departureTime: "00:15",
            arrivalTime: "04:00",
            action: { print("Clear") },
        )
    }
    .padding()
}
