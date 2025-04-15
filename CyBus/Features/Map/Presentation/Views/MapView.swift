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
    @Bindable var locationStore: StoreOf<LocationFeature>
    @Bindable var busesStore: StoreOf<BusesFeature>
    @Bindable var searchStore: StoreOf<SearchFeatures>
    
    @Environment(\.theme) var theme
    
    @State private var position: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @Namespace private var mapScope
    
    let strokeStyle = StrokeStyle(
        lineWidth: 3,
        lineCap: .round,
        lineJoin: .round,
        dash: [5, 5]
    )
        
    let gradient = Gradient(colors: [.red, .green, .blue])
    
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
                    position: $position,
                    interactionModes: MapInteractionModes.all,
                    scope: mapScope
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
                        .stroke(gradient, style: strokeStyle)
                    }
                    
                    //MARK: Destination marker
                    if searchStore.searchAddressResult.hasSuggestion {
                        let suggestion = searchStore.searchAddressResult.detailedSuggestion
                        Marker(suggestion?.name, coordinate: suggestion?.location)
                    }
                }
                .mapControls {
                    MapPitchToggle(scope: mapScope)
                    MapUserLocationButton(scope: mapScope)
                }
                .mapStyle(.standard)
                .mapControlVisibility(.visible)
                .alert($mapStore.scope(state: \.alert, action: \.alert))
                
                // MARK: Clear route button
                VStack {
                    Spacer()
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

