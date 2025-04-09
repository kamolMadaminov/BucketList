//
//  ContentView.swift
//  BucketList
//
//  Created by Kamol Madaminov on 08/04/25.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.311, longitude: 69.279),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    @StateObject private var viewModel = ViewModel()
    @State private var isEditing = false
    @State private var mapStyle: MapStyle = .standard
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isUnlocked {
                    MapReader { proxy in
                        Map(initialPosition: startPosition) {
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 45, height: 45)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .contextMenu {
                                            Button("Edit") {
                                                 viewModel.selectedPlace = location
                                                 isEditing = true
                                            }
                                        }
                                }
                            }
                        }
                        .mapStyle(mapStyle)
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        .sheet(isPresented: $isEditing) {
                            if let place = viewModel.selectedPlace {
                                EditView(location: place) {
                                    viewModel.update(location: $0)
                                }
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Menu {
                                    Button("Standard") {
                                        mapStyle = .standard
                                    }
                                    Button("Hybrid") {
                                        mapStyle = .hybrid
                                    }
                                } label: {
                                    Image(systemName: "map")
                                }
                            }
                        }

                    }
                } else {
                    VStack {
                        Button("Authenticate") {
                            viewModel.authenticate()
                        }
                    }
                    .alert("Please, try again", isPresented: $viewModel.showErrorMessage) {
                        Button("OK") {}
                    } message: {
                        Text(viewModel.errorMessage)
                    }
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
                }
            }
            .navigationTitle("Bucket List")
        }
    }
}

#Preview {
    ContentView()
}
