//
//  MapView.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: viewModel.buses) { bus in
            MapPin(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(bus.currentLocation.latitude), longitude: CLLocationDegrees(bus.currentLocation.longitude)))
        }
        .onAppear {
            viewModel.loadBuses()
        }
    }
}

#Preview {
    MapView()
}

