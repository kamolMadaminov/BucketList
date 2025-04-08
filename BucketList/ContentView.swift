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
    
    @State private var locations = [Location]()
    @State private var selectedPlace: Location?
    
    var body: some View {
        
        MapReader{ proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 45, height: 45)
                            .background(.white)
                            .clipShape(.circle)
                            .contextMenu {
                                Button("Edit") {
                                    selectedPlace = location
                                }
                            }

                    }


                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let newLocation = Location(id: UUID(), name: "New location", description: "", longitude: coordinate.longitude, latitude: coordinate.latitude)
                    locations.append(newLocation)
                }
            }
            .sheet(item: $selectedPlace) { place in
                EditView(location: place) { newLocation in
                    if let index = locations.firstIndex(of: place){
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
