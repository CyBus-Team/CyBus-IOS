//
//  MapView.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
import MapKit
import ComposableArchitecture

struct MapView: View {
    
    @Bindable var mapStore: StoreOf<MapFeature>
    @Bindable var busesStore: StoreOf<BusesFeature>
    @Bindable var searchStore: StoreOf<SearchFeatures>
    
    @Environment(\.theme) var theme
    
    var body: some View {
        if mapStore.error != nil {
            VStack {
                Text(mapStore.error ?? "Unknown error")
            }
            
        } else if mapStore.isLoading {
            VStack {
                ProgressView()
                Text("Loading...")
            }
            
        } else {
            ZStack {
                // MARK: Map
                Map(
                    position: $mapStore.cameraPosition,
                    interactionModes: MapInteractionModes.all
                ) {
                    UserAnnotation()
                    ForEach(busesStore.busList) { bus in
                        Annotation("", coordinate: bus.position, anchor: .bottom) {
                            BusView(
                                bus: bus,
                                isActive: !busesStore.hasSelection || bus == busesStore.selectedBus
                            ) {
                                busesStore.send(.select(bus))
                            }
                        }
                    }
                    
                    //MARK: Stops and Shapes
                    if busesStore.routes.hasSelectedRoute {
                        let route = busesStore.routes.selectedRoute
                        let stops = route?.stops ?? []
                        let shapes = route?.shapes ?? []
                        
                        //MARK: Stops
                        ForEach(stops) { stop in
                            Annotation("", coordinate: stop.position) {
                                StopCircle(color: theme.colors.primary).compositingGroup()
                            }
                        }
                        
                        //MARK: Shapes
                        MapPolyline(
                            coordinates: shapes.map { shape in
                                shape.position
                            }
                        )
                        .stroke(
                            .blue, style: StrokeStyle(
                                lineWidth: 3,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                    }
                    
                    //MARK: Destination marker
                    if searchStore.searchAddressResult.hasSuggestion {
                        let suggestion = searchStore.searchAddressResult.detailedSuggestion
                        if let location = suggestion?.location {
                            Annotation(suggestion?.name ?? "-", coordinate: location) {
                                DestinationMarker {
                                    searchStore.send(.onOpenAddressSearchResults)
                                }
                            }
                        }
                    }
                    
                    //MARK: Trip
                    if searchStore.searchAddressResult.hasSuggestedTrips {
                        let legs = searchStore.searchAddressResult.suggestedTrips.first!.legs
                        ForEach(legs) { leg in
                            MapPolyline(coordinates: leg.points)
                                .stroke(
                                    leg.lineColor,
                                    style: StrokeStyle(
                                        lineWidth: 3,
                                        lineCap: .round,
                                        lineJoin: .round,
                                        dash: [5, 5]
                                    )
                                )
                        }
                    }
                }
                .mapControls {
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                .mapStyle(.standard)
                .mapControlVisibility(.visible)
                .alert($mapStore.scope(state: \.alert, action: \.alert))
                
                
                VStack {
                    // MARK: Path tips
                    if searchStore.searchAddressResult.hasSuggestedTrips {
                        PathTips(
                            legs: searchStore.searchAddressResult.suggestedTrips.first!.legs,
                            hasSelectedLine: busesStore.hasSelection
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    // MARK: Clear route button
                    if busesStore.hasSelection {
                        ClearRouteButton {
                            busesStore.send(.clearSelection)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            
        }
    }
}

