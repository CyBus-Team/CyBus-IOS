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
        if let mapBoxAccessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String {
            MapboxOptions.accessToken = mapBoxAccessToken
        } else {
            assertionFailure("Can't get MBX access token")
        }
        
    }
    
    var body: some View {
        ZStack {
            // Map
            Map(
                viewport: $viewport
            ) {
                // Bus marker
                ForEvery(viewModel.buses) { bus in
                    MapViewAnnotation(coordinate: bus.position) {
                        BusLineLabel(lineName: bus.lineName).onTapGesture {
                            viewModel.onSelectBus(bus: bus)
                        }
                    }.allowOverlap(true)
                }
                
                // Bus route
                if let selectedBus = viewModel.selectedBus {
                    let busRoute = selectedBus.1
                    ForEvery(busRoute.stops) { stop in
                        MapViewAnnotation(coordinate:  stop.position) {
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
                    
                    PolylineAnnotationGroup {
                        PolylineAnnotation(id: "route-feature", lineCoordinates: busRoute.shapes.map { shape in
                            shape.position
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
                viewModel.onMapLoaded()
            }
            
            VStack {
                Spacer()
                HStack(
                    alignment: .center
                ) {
                    // Clear route button
                    if (viewModel.hasSelection) {
                        ClearRouteButton {
                            viewModel.onClearSelection()
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

