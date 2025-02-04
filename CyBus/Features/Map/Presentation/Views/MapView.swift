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
    @Bindable var searchStore: StoreOf<SearchFeatures>
    
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
                    PrimaryButton(label:String(localized: "Retry")) {
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
                    
                    //MARK: - Map view
                    Map(viewport: $cameraStore.viewport) {
                        
                        //MARK: User location
                        Puck2D(bearing: .course)
                            .showsAccuracyRing(true)
                        
                        //MARK: Buses
                        ForEvery(busesStore.groupedBuses) { busGroup in
                            MapViewAnnotation(coordinate: busGroup.position) {
                                BusGroup (
                                    action: { busesStore.send(.select(busGroup)) },
                                    activeBus: busesStore.selectedBusGroupState?.bus,
                                    buses: busGroup.buses,
                                    scale: cameraStore.scale
                                )
                            }
                            .variableAnchors([.init(anchor: .bottom)])
                            .allowOverlap(true)
                        }
                        
                        if busesStore.routes.hasSelectedRoute {
                            let route = busesStore.routes.selectedRoute
                            let stops = route?.stops ?? []
                            let shapes = route?.shapes ?? []
                            
                            //MARK: Stops
                            ForEvery(stops) { stop in
                                MapViewAnnotation(coordinate: stop.position) {
                                    StopCircle(color: theme.colors.primary).compositingGroup()
                                }
                                .allowZElevate(true)
                                .allowOverlap(true)
                            }
                            
                            //MARK: Shapes
                            PolylineAnnotation(
                                lineCoordinates: shapes.map { shape in
                                    shape.position
                                }
                            )
                            .lineColor(.systemBlue)
                            .lineWidth(3)
                        }
                        
                        //MARK: - Destaniation path
                        let nodes = searchStore.searchAddressResult.nodes
                        if !nodes.isEmpty {
                            ForEvery(nodes) { node in
                                MapViewAnnotation(coordinate: node.location) {
                                    VStack {
                                        Text(node.id)
                                        StopCircle(color: theme.colors.secondary)
                                    }
                                }
                                .allowZElevate(false)
                                .allowOverlap(true)
                            }
                        }
                        
                        //MARK: - Destination marker
                        if searchStore.searchAddressResult.hasSuggestion {
                            MapViewAnnotation(coordinate: searchStore.searchAddressResult.detailedSuggestion!.location) {
                                DestinationMarker {
                                    searchStore.send(.onOpenAddressSearchResults)
                                }
                            }
                            .allowZElevate(false)
                            .allowOverlap(true)
                        }
                        
                    }
                    .mapStyle(.light)
                    .cameraBounds(CameraBoundsOptions(maxZoom: CameraFeature.maxZoom, minZoom: CameraFeature.minZoom))
                    
                    //MARK: - Map actions
                    VStack {
                        Spacer()
                        HStack(alignment: .center) {
                            
                            // MARK: Clear route button
                            if busesStore.hasSelection {
                                ClearRouteButton {
                                    busesStore.send(.clearSelection)
                                }
                            }
                            
                            //MARK: Zoom button
                            ZoomControlView(onZoomIn: { cameraStore.send(.increaseZoom) }, onZoomOut: { cameraStore.send(.decreaseZoom) } )
                            
                            Spacer()
                            
                            //MARK: Get current location button
                            LocationButton {
                                locationStore.send(.getCurrentLocation)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 50)
                        .padding(.horizontal, 20)
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

