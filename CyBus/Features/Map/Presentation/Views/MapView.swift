//
//  MapView.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
import MapKit
import ComposableArchitecture

let footStroke = StrokeStyle(
    lineWidth: 3,
    lineCap: .round,
    lineJoin: .round,
    dash: [5, 5]
)
let busStroke = StrokeStyle(
    lineWidth: 3,
    lineCap: .round,
    lineJoin: .round
)

struct MapView: View {
    
    @Bindable var mapStore: StoreOf<MapFeature>
    @Bindable var busesStore: StoreOf<BusesFeature>
    @Bindable var searchStore: StoreOf<SearchFeatures>
    
    @Environment(\.theme) var theme
    
    var body: some View {
        if let error = mapStore.error {
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
                        .stroke(.blue, style: busStroke)
                    }
                    
                    //MARK: Destination marker
                    if searchStore.searchAddressResult.hasSuggestion {
                        let suggestion = searchStore.searchAddressResult.suggestion
                        if let location = suggestion?.location {
                            Annotation(suggestion?.label ?? "-", coordinate: location) {
                                DestinationMarker {
                                    searchStore.send(.onOpenAddressSearchResults)
                                }
                            }
                        }
                    }
                    
                    //MARK: Trip
                    if let selectedTrip = searchStore.searchAddressResult.selectedTrip {
                        ForEach(selectedTrip.legs) { leg in
                            MapPolyline(coordinates: leg.points)
                                .stroke(
                                    leg.lineColor,
                                    style: leg.mode == .bus ? busStroke : footStroke
                                )
                            if let last = leg.points.last {
                                Annotation("", coordinate: last) {
                                    StopCircle(color: leg.lineColor).compositingGroup()
                                }
                            }
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
                    if let trip = searchStore.searchAddressResult.selectedTrip {
                        PathTips(
                            legs: trip.legs,
                            hasSelectedLine: busesStore.hasSelection
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .onTapGesture {
                            searchStore.send(.onOpenAddressSearchResults)
                        }
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

