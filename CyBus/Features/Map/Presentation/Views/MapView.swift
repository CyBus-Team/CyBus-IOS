//
//  MapView.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
import MapboxMaps

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            
            // Map
            Map(viewport: $cameraViewModel.viewport) {
                
                // Buses
                ForEvery(mapViewModel.buses) { bus in
                    MapViewAnnotation(coordinate: bus.position) {
                        Bus(lineName: bus.lineName)
                            .onTapGesture {
                                mapViewModel.onSelectBus(bus: bus)
                            }
                    }.allowOverlap(true)
                }
                
                if let selection = mapViewModel.selection {
                    let bus = selection.1
                    
                    // Stops
                    ForEvery(bus.stops) { stop in
                        MapViewAnnotation(coordinate: stop.position) {
                            StopCircle().compositingGroup()
                        }.allowOverlap(true)
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
            .mapStyle(.light)
            .cameraBounds(CameraBoundsOptions(maxZoom: cameraViewModel.maxZoom, minZoom: cameraViewModel.minZoom))
            .onMapLoaded { map in
                mapViewModel.onMapLoaded()
            }
            
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    // Clear route button
                    if mapViewModel.hasSelection {
                        ClearRouteButton {
                            mapViewModel.onClearSelection()
                        }
                    }
                    
                    // Zoom buttons
                    ZoomButton(
                        action: {
                            withViewportAnimation(.fly) {
                                cameraViewModel.decreaseZoom()
                            }
                        },
                        zoomIn: false
                    )
                    ZoomButton(
                        action: {
                            withViewportAnimation(.fly) {
                                cameraViewModel.increaseZoom()
                            }
                        },
                        zoomIn: true
                    )
                    
                    // Get current location button
                    LocationButton {
                        withViewportAnimation(.fly) {
                            cameraViewModel.goToCurrentLocation()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea()
    }
}
