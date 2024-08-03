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
    // Initializes viewport state as styleDefault,
    // which will use the default camera for the current style.
    @State var viewport: Viewport = .styleDefault
    @State var zoom: Double = 13
    
    init() {
        // TODO: Setup env - (issue)[https://github.com/PopovVA/CyBus/issues/3]
        MapboxOptions.accessToken = ""
    }
    
    var body: some View {
        ZStack {
            // Map
            Map(
                viewport: $viewport
            ) {
                // Bus marker
                ForEvery(viewModel.buses) { bus in
                    MapViewAnnotation(coordinate: bus.location) {
                        BusMarkerView(bus: bus).onTapGesture {
                            viewModel.getRoute(for: bus)
                        }
                    }
                }
                
                // Bus route
                if !viewModel.route.isEmpty {
                    PolylineAnnotationGroup {
                        PolylineAnnotation(id: "route-feature", lineCoordinates: viewModel.route.map { shape in
                            shape.location
                        })
                        .lineColor(.systemBlue)
                        .lineBorderColor(.systemBlue)
                        .lineWidth(10)
                        .lineBorderWidth(2)
                    }
                    .layerId("route")
                    .lineCap(.round)
                    .slot("middle")
                }
            }.onMapLoaded { _ in
                viewModel.loadBuses()
            }
            
            // Clear route
            VStack {
                Spacer()
                HStack {
                    if !viewModel.route.isEmpty {
                        ClearRouteButton {
                            viewModel.clearRoute()
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.bottom, 40)
            }
            
            // Get current location button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    LocationButton {
                        // TODO: Get current location
                        let center = CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617)
                        withViewportAnimation {
                            viewport = .camera(center: center, zoom: zoom, bearing: 0, pitch: 0)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 40)
                }
            }
            
            // Zoom out button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        zoom -= 1
                        withViewportAnimation {
                            viewport = .camera(zoom: zoom)
                        }
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
}

