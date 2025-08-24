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
    lineWidth: 7,
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
                Spacer()
                Text(mapStore.error ?? "Unknown error: \(error)")
                Spacer()
            }
            
        } else if mapStore.isLoading {
            VStack {
                Spacer()
                ProgressView()
                Text("Loading...")
                Spacer()
            }
            
        } else {
            ZStack {
                // MARK: Map
                MapReader { proxy in
                    Map(
                        position: $mapStore.cameraPosition,
                        interactionModes: MapInteractionModes.all
                    ) {
                        UserAnnotation()
                        //MARK: Selected trip buses
                        if let selectedLines = searchStore.searchAddressResult.selectedTrip?.legs.compactMap({ $0.line }) {
                            ForEach(busesStore.buses.filter { selectedLines.contains($0.shortLabel) } ) { bus in
                                Annotation("", coordinate: bus.position, anchor: .bottom) {
                                    busItemView(for: bus, selectedBus: busesStore.selectedBus) {
                                        busesStore.send(.select(bus))
                                    }
                                }
                            }
                        //MARK: All buses
                        } else {
                            ForEach(busesStore.clusters.indices, id: \.self) { idx in
                                let cluster = busesStore.clusters[idx]
                                Annotation("", coordinate: cluster.coordinate, anchor: .bottom) {
                                    if cluster.buses.count == 1 {
                                        busItemView(for: cluster.buses[0], selectedBus: busesStore.selectedBus) {
                                            busesStore.send(.select(cluster.buses[0]))
                                        }
                                    } else {
                                        ZStack {
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 30, height: 30)
                                            Text("\(cluster.buses.count)")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                        }
                        
                        //MARK: Stops and Shapes
                        if busesStore.route.hasSelectedRoute {
                            let route = busesStore.route.selectedRoute
                            let stops = route?.stops ?? []
                            let shape = route?.shape ?? []
                            
                            //MARK: Stops
                            ForEach(stops.indices, id: \.self) { idx in
                                let stop = stops[idx]
                                Annotation(stop.description, coordinate: stop.position) {
                                    StopCircle(color: theme.colors.primary).compositingGroup()
                                }
                            }

                            //MARK: Shapes
                            MapPolyline(
                                coordinates: shape.map { shape in
                                    shape.position
                                }
                            )
                            .stroke(.blue, style: busStroke)
                        }
                        
                        //MARK: Destination marker
                        if let suggestion = searchStore.searchAddressResult.suggestion {
                            Annotation(suggestion.label, coordinate: suggestion.location) {
                                DestinationMarker {
                                    searchStore.send(.onOpenAddressSearchResults)
                                }
                                .contentShape(Rectangle())
                                .allowsHitTesting(true)
                                .zIndex(10)
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
                    .onMapCameraChange(frequency: .onEnd) { context in
                        busesStore.send(.onDistanceChanged(context.camera.distance))
                    }
                    .mapControls {
                        MapPitchToggle()
                        MapUserLocationButton()
                        MapCompass()
                    }
                    .mapStyle(.standard)
                    .mapControlVisibility(.visible)
                    .gesture(
                        LongPressGesture(minimumDuration: 0.5)
                            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                            .onEnded { value in
                                switch value {
                                case .second(true, let drag?):
                                    let location = drag.location
                                    if let coordinate = proxy.convert(location, from: .local) {
                                        mapStore.send(.tapOnMap(coordinate))
                                    }
                                default:
                                    break
                                }
                            }
                    )
                    .alert($mapStore.scope(state: \.alert, action: \.alert))
                }
                VStack {
                    // MARK: Path tips
                    if let trip = searchStore.searchAddressResult.selectedTrip {
                        PathTips(legs: trip.legs, selectedBus: busesStore.selectedBus)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .onTapGesture {
                                searchStore.send(.onOpenAddressSearchResults)
                            }
                    }
                    
                    Spacer()
                    // MARK: Route info view
                    if let selectedRoute = busesStore.route.selectedRoute, let _ = busesStore.selectedBus {
                        routeInfoView(for: selectedRoute)
                        .padding(8)
                    }
                }
                .padding(.bottom, 30)
                
                // MARK: Bus Loading notification
                VStack {
                    if busesStore.isFetching && busesStore.buses.isEmpty {
                        busesFirstLoadingNotification()
                    }
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: busesStore.isFetching)
            }
            
        }
    }
    
    @ViewBuilder
    func busesFirstLoadingNotification() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "bus.fill")
                .foregroundColor(.white)
                .padding(6)
                .background(Circle().fill(Color.blue))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Updating buses and routes...")
                    .font(.subheadline)
                    .bold()
                Text("This will only take a few seconds")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(radius: 8)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func routeInfoView(for route: RouteEntity) -> some View {
        RouteInfoView(
            routeName: route.routeName,
            routeNumber: route.routeNumber,
            departureTime: route.departureTime,
            arrivalTime: route.arrivalTime,
        ) {
            busesStore.send(.clearSelection)
        }
    }
    
    @ViewBuilder
    func busItemView(for bus: BusEntity, selectedBus: BusEntity?, action: @escaping () -> Void) -> some View {
        let state: BusViewState = {
            if let selected = selectedBus {
                return selected == bus ? .selected : .unselected
            } else {
                return .none
            }
        }()
        
        BusView(bus: bus, state: state, action: action)
    }
}
