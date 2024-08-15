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
    @State var zoom: Double = 12
    
    let center = CLLocationCoordinate2D(latitude: 34.707130, longitude: 33.022617)
    
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
                            viewModel.getShapes(for: bus)
                        }
                    }
                }
                
                // Bus route
                if let busRoute = viewModel.route {
                    ForEvery(busRoute.stops) { stop in
                        MapViewAnnotation(coordinate:  CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(stop.latitude) ?? 0,
                            longitude: CLLocationDegrees(stop.longitude) ?? 0
                        )) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 20, height: 20)
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 10, height: 10)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                        }
                    }
                    
                    let shapes = busRoute.shapes
                    PolylineAnnotationGroup {
                        PolylineAnnotation(id: "route-feature", lineCoordinates: shapes.map { shape in
                            CLLocationCoordinate2D(
                                latitude: CLLocationDegrees(shape.latitude ) ?? 0,
                                longitude: CLLocationDegrees(shape.longitude ) ?? 0
                            )
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
                viewport = .camera(center: center, zoom: zoom)
                viewModel.loadBuses()
            }
            
            VStack {
                Spacer()
                HStack(
                    alignment: .center
                ) {
                    // Clear route button
                    if (viewModel.route != nil) {
                        ClearRouteButton {
                            viewModel.clearRoute()
                        }
                    }
                    // Zoom buttons
                    ZoomButton(
                        action: {
                            zoom -= 1
                            withViewportAnimation {
                                viewport = .camera(zoom: zoom)
                            }
                        },
                        zoomIn: false
                    )
                    ZoomButton(
                        action: {
                            zoom += 1
                            withViewportAnimation {
                                viewport = .camera(zoom: zoom)
                            }
                        },
                        zoomIn: true
                    )
                    // Get current location button
                    LocationButton {
                        // TODO: Get current location
                        withViewportAnimation {
                            viewport = .camera(center: center, zoom: zoom, bearing: 0, pitch: 0)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 40)
            }
        }.ignoresSafeArea()
    }
    
}

