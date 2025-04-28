//
//  TripsSelectionView.swift
//  CyBus
//
//  Created by Vadim Popov on 21/04/2025.
//

import SwiftUI
import ComposableArchitecture
import Foundation
import CoreLocation

struct TripSelectionView : View {
    @Environment(\.theme) var theme
    
    @Bindable var store: StoreOf<AddressSearchResultFeature>
    
    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text(LocalizedStringKey("Click on trip to select"))
                    .padding()
                ForEach(store.suggestedTrips) { (trip: SearchTripEntity) in
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Text("Start at")
                            Text(DateFormatter.localizedString(
                                from: trip.startTime,
                                dateStyle: .none,
                                timeStyle: .short
                            ))
                            Text(" - ")
                            Text("Finish at")
                            Text(DateFormatter.localizedString(
                                from: trip.endTime,
                                dateStyle: .none,
                                timeStyle: .short
                            ))
                        }
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(trip.legs) { leg in
                                HStack {
                                    VStack(spacing: 2) {
                                        Image(systemName: leg.mode == .foot ? "figure.walk" : "bus.fill")
                                        Text(leg.line ?? "Walk")
                                    }
                                    .padding(.vertical, 4)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.white)
                                    .background(leg.lineColor)
                                    .cornerRadius(12)
                                    Text(leg == trip.legs.last ? "🏁" : "➡")
                                        .backgroundStyle(.separator)
                                }
                            }
                        }
                    }
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(trip == store.selectedTrip ? .blue : .white, lineWidth: 2)
                    )
                    .font(.caption)
                    .onTapGesture {
                        store.send(.onChooseTrip(trip))
                    }
                    Divider()
                        .frame(height: 1)
                        .background(.separator)
                }
                Spacer()
            }
            Spacer()
            HStack {
                PrimaryButton(
                    label: String(localized: "Go"),
                    action: {
                        store.send(.onCloseTrips)
                    },
                    isLoading: false,
                    font: theme.typography.regular
                )
                Spacer()
            }
        }
        .padding()
        .background(theme.colors.background)
        
    }
}

#Preview {
    let trip1 = SearchTripEntity(id: "id", duration: .seconds(10), distance: 1000, formattedDistance: "10km", startTime: Date(), endTime: Date(), legs: [
        LegEntity(id: "id2", points: [CLLocationCoordinate2D(latitude: 34.6789, longitude: 33.1234)], mode: .bus, line: "30", lineColor: .red),
        LegEntity(id: "id3", points: [CLLocationCoordinate2D(latitude: 34.6789, longitude: 33.1234)], mode: .bus, line: "10", lineColor: .orange),
        LegEntity(id: "id4", points: [CLLocationCoordinate2D(latitude: 34.6789, longitude: 33.1234)], mode: .foot, line: nil, lineColor: .blue),
        LegEntity(id: "id5", points: [CLLocationCoordinate2D(latitude: 34.6789, longitude: 33.1234)], mode: .bus, line: "1", lineColor: .pink),
        LegEntity(id: "id6", points: [CLLocationCoordinate2D(latitude: 34.6789, longitude: 33.1234)], mode: .foot, line: nil, lineColor: .pink)
    ])
    let trip2 = SearchTripEntity(id: "id2", duration: .seconds(10), distance: 1000, formattedDistance: "10km", startTime: Date(), endTime: Date(), legs: [
        LegEntity(id: "id3", points: [CLLocationCoordinate2D(latitude: 34.6789, longitude: 33.1234)], mode: .foot, line: nil, lineColor: .blue)
    ])
    let trips = [trip1, trip2]
    TripSelectionView(store: Store(initialState: AddressSearchResultFeature.State(
        suggestedTrips: trips,
        selectedTrip: trip1,
        isLoading: false,
        isTripsLoading: false
    )) {
        AddressSearchResultFeature()
    })
}
