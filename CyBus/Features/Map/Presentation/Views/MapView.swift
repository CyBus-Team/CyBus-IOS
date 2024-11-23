//
//  MapView.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
import MapboxMaps
import ComposableArchitecture

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    
    @Bindable var mapStore: StoreOf<MapFeature>
    @Bindable var cameraStore: StoreOf<CameraFeature>
    @Bindable var locationStore: StoreOf<LocationFeature>
    
    @Environment(\.theme) var theme
    
    var body: some View {
        ZStack {
            
            // Map
            Map(viewport: $cameraStore.viewport) {
                
                //User location
                Puck2D(bearing: .heading)
                    .showsAccuracyRing(true)
                
                // Buses
                ForEvery(mapViewModel.buses) { bus in
                    MapViewAnnotation(coordinate: bus.position) {
                        Bus(name: bus.lineName, color: theme.colors.primary)
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
                        }
                        .allowOverlap(true)
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
            .cameraBounds(CameraBoundsOptions(maxZoom: CameraFeature.maxZoom, minZoom: CameraFeature.minZoom))
            .onMapLoaded { map in
                mapStore.send(.onMapInit)
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
                            cameraStore.send(.decreaseZoom)
                        },
                        zoomIn: false
                    )
                    ZoomButton(
                        action: {
                            cameraStore.send(.increaseZoom)
                        },
                        zoomIn: true
                    )
                    
                    // Get current location button
                    LocationButton {
                        locationStore.send(.goToCurrentLocation)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 100)
            }
        }.alert($mapStore.scope(state: \.alert, action: \.alert))
        .ignoresSafeArea()
        
    }
}

