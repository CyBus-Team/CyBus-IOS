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
    
    var body: some View {
        ZStack {
            
            // Map
            Map(viewport: $viewModel.viewport) {
                
                // Buses
                ForEvery(viewModel.buses) { bus in
                    MapViewAnnotation(coordinate: bus.position) {
                        Bus(lineName: bus.lineName)
                            .onTapGesture {
                                viewModel.onSelectBus(bus: bus)
                            }
                    }.allowOverlap(true).variableAnchors([ViewAnnotationAnchorConfig(anchor:.center)])
                }
                
                if let selection = viewModel.selection {
                    let bus = selection.1
                    
                    // Stops
                    ForEvery(bus.stops) { stop in
                        MapViewAnnotation(coordinate: stop.position) {
                            StopCircle().compositingGroup()
                        }.allowOverlap(false).variableAnchors([ViewAnnotationAnchorConfig(anchor: .top)])
                    }
                    
                    // Shapes
                    PolylineAnnotation(
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
            .cameraBounds(CameraBoundsOptions(maxZoom: viewModel.maxZoom, minZoom: viewModel.minZoom))
            .onMapLoaded { _ in
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
                            withViewportAnimation(.fly) {
                                viewModel.decreaseZoom()
                            }
                        },
                        zoomIn: false
                    )
                    ZoomButton(
                        action: {
                            withViewportAnimation(.fly) {
                                viewModel.increaseZoom()
                            }
                        },
                        zoomIn: true
                    )
                    
                    // Get current location button
                    LocationButton {
                        withViewportAnimation(.fly) {
                            viewModel.goToCurrentLocation()
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
