//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Kamol Madaminov on 09/04/25.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit
import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        @Published var isUnlocked = false
        @Published var showErrorMessage = false
        @Published var errorMessage = ""
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch{
                locations = []
            }
        }
        
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch{
                print("Unable to save data.")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New location", description: "", longitude: point.longitude, latitude: point.latitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location){
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace){
                locations[index] = location
                save()
            }
        }
        
        func authenticate(){
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please, authenticate to unlock your places!"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [self] success, authenticationError in
                    DispatchQueue.main.async {
                        if success{
                            self.isUnlocked = true
                        } else{
                            self.isUnlocked = false
                            self.showErrorMessage = true
                            self.errorMessage = authenticationError?.localizedDescription ?? "Unknown error"
                        }
                    }
                }
            } else {
                // no biometrics
            }
        }
        
    }
}
