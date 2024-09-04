//
//  MapView.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    @State private var viewport: Viewport = .styleDefault
    @State private var zoom: Double = 14
    
    let center = CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617)
    
    var body: some View {
        ZStack {
            
            // Map
            Map(viewport: $viewport) {
                
                // Buses
                ForEvery(viewModel.buses) { bus in
                    MapViewAnnotation(coordinate: bus.position) {
                        Bus(lineName: bus.lineName)
                            .onTapGesture {
                                viewModel.onSelectBus(bus: bus)
                            }
                    }
                    .allowOverlap(true)
                }
                
                if let selection = viewModel.selection {
                    let bus = selection.1
                    
                    // Stops
                    ForEvery(bus.stops) { stop in
                        MapViewAnnotation(coordinate: stop.position) {
                            StopCircle().compositingGroup()
                        }
                
                    }
                
                // Shapes
                PolylineAnnotation(
                    id: "shapes",
                    lineCoordinates: bus.shapes.map { shape in
                        shape.position
                    }
                )
                .lineColor(.systemBlue)
                .lineBorderColor(.systemBlue)
                .lineWidth(10)
                .lineBorderWidth(2)
            }
        }
        .onMapLoaded { _ in
            viewport = .camera(center: center, zoom: zoom)
            viewModel.onMapLoaded()
        }
        
        VStack {
            Spacer()
            HStack(alignment: .center) {
                // Clear route button
                if viewModel.hasSelection {
                    ClearRouteButton {
                        viewModel.onClearSelection()
                    }
                }
                
                // Zoom buttons
                ZoomButton(
                    action: {
                        zoom -= 1
                        withViewportAnimation(.fly) {
                            viewport = .camera(zoom: zoom)
                        }
                    },
                    zoomIn: false
                )
                ZoomButton(
                    action: {
                        zoom += 1
                        withViewportAnimation(.fly) {
                            viewport = .camera(zoom: zoom)
                        }
                    },
                    zoomIn: true
                )
                
                // Get current location button
                LocationButton {
                    // TODO: Get current location
                    withViewportAnimation(.fly) {
                        viewport = .camera(center: center, zoom: zoom, bearing: 0, pitch: 0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 40)
        }
    }
        .ignoresSafeArea()
}
}
