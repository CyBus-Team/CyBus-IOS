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
    
    @Bindable var mapStore: StoreOf<MapFeature>
    @Bindable var cameraStore: StoreOf<CameraFeature>
    @Bindable var locationStore: StoreOf<LocationFeature>
    @Bindable var busesStore: StoreOf<BusesFeature>
    
    @Environment(\.theme) var theme
    
    private func onInit() {
        mapStore.send(.setUp)
        busesStore.send(.setUp)
        busesStore.send(.routes(.setUp))
    }
    
    var body: some View {
        
        NavigationStack {
            
            if mapStore.error != nil {
                VStack {
                    Text(mapStore.error ?? "Unknown error")
                    PrimaryButton(label:"Retry") {
                        onInit()
                    }
                }
                
            } else if mapStore.isLoading {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
                
            } else {
                ZStack {
                    
                    // Map
                    Map(viewport: $cameraStore.viewport) {
                        
                        //User location
                        Puck2D(bearing: .heading)
                            .showsAccuracyRing(true)
                        
                        // Buses
                        ForEvery(busesStore.groupedBuses) { busGroup in
                            MapViewAnnotation(coordinate: busGroup.position) {
                                Bus(
                                    lines: busGroup.allLines,
                                    state: busesStore.selectedBusGroupState?.group != busGroup
                                    ? busesStore.hasSelection ? .inactive : .none : .active,
                                    scale: cameraStore.scale,
                                    activeBusIndex: busesStore.selectedBusGroupState?.index
                                )
                                .onTapGesture {
                                    busesStore.send(.select(busGroup))
                                }
                            }
                            .variableAnchors([.init(anchor: .bottom)])
                            .allowOverlap(true)
                        }
                        
                        if busesStore.routes.hasSelectedRoute {
                            let route = busesStore.routes.selectedRoute
                            let stops = route?.stops ?? []
                            let shapes = route?.shapes ?? []
                            
                            // Stops
                            ForEvery(stops) { stop in
                                MapViewAnnotation(coordinate: stop.position) {
                                    StopCircle(color: theme.colors.primary).compositingGroup()
                                }
                                .allowOverlap(true)
                            }
                            
                            // Shapes
                            PolylineAnnotation(
                                lineCoordinates: shapes.map { shape in
                                    shape.position
                                }
                            )
                            .lineColor(.systemBlue)
                            .lineWidth(3)
                        }
                    }
                    .mapStyle(.light)
                    .cameraBounds(CameraBoundsOptions(maxZoom: CameraFeature.maxZoom, minZoom: CameraFeature.minZoom))
                    
                    VStack {
                        Spacer()
                        HStack(alignment: .center) {
                            // Clear route button
                            if busesStore.hasSelection {
                                ClearRouteButton {
                                    busesStore.send(.clearSelection)
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
                                locationStore.send(.getCurrentLocation)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 100)
                    }
                }
                .alert($mapStore.scope(state: \.alert, action: \.alert))
                .ignoresSafeArea()
            }
        }
        .onAppear() {
            onInit()
        }
        
    }
}

