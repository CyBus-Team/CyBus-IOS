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
                    
                    //MARK: Shapes and Stops
                    //                    if busesStore.routes.hasSelectedRoute {
                    //                        let route = busesStore.routes.selectedRoute
                    //                        let stops = route?.stops ?? []
                    //                        let shapes = route?.shapes ?? []
                    //
                    //                        //MARK: Stops
                    //                        ForEach(stops) { stop in
                    //                            MapAnnotation(coordinate: stop.position) {
                    //                                StopCircle(color: theme.colors.primary).compositingGroup()
                    //                            }
                    //                        }
                    //                    }
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

