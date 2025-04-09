//
//  EditViewModel.swift
//  BucketList
//
//  Created by Kamol Madaminov on 09/04/25.
//

import SwiftUI

class EditViewModel: ObservableObject {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Published var name: String
    @Published var description: String
    @Published var pages = [Page]()
    @Published var loadingState: LoadingState = .loading
    
    var location: Location
    var onSave: (Location) -> Void
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = Published(initialValue: location.name)
        _description = Published(initialValue: location.description)
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Invalid url: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
    
    func save() {
        var newLocation = location
        newLocation.name = name
        newLocation.description = description
        newLocation.id = UUID()
        
        onSave(newLocation)
    }
}
