//
//  SearchView.swift
//  CWK2_23_GL
//
//  Created by GirishALukka on 11/03/2023.
//
import SwiftUI
import CoreLocation

struct SearchView: View {
    @EnvironmentObject var modelData: ModelData
    
    // Bindings to manage the search view state and user location
    @Binding var isSearchOpen: Bool
    @State var location = ""
    @Binding var userLocation: String
    
    // State variables for alert management
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        
        ZStack {
            
            Color.teal
                .ignoresSafeArea()
            
            
            VStack {
                // TextField for  new location
                TextField("Enter New Location", text: self.$location, onCommit: {
                    // Check for user input
                    if !isinputvalid(input: location) {
                        alertTitle = "Invalid Input"
                        alertMessage = "Please enter a valid location with only alphabetic characters."
                        showingAlert = true
                        return
                    }
                    
                    // Geocode the location for latitude and longitude
                    CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                        // Handle geocoding errors
                        if let error = error {
                            alertTitle = "Error"
                            alertMessage = error.localizedDescription
                            showingAlert = true
                            return
                        }
                        
                        // Get latitude and longitude from the geocoded location
                        guard let placemark = placemarks?.first, let lat = placemark.location?.coordinate.latitude, let lon = placemark.location?.coordinate.longitude else {
                            alertTitle = "Location Not Found"
                            alertMessage = "Unable to geocode location. Please try again."
                            showingAlert = true
                            return
                        }
                        
                        // Load weather data
                        Task {
                            do {
                                try await modelData.loadData(lat: lat, lon: lon)
                                userLocation = location
                                modelData.userLocation = location
                                isSearchOpen.toggle()
                            } catch {
                                alertTitle = "Error"
                                alertMessage = error.localizedDescription
                                showingAlert = true
                            }
                        }
                    }
                })
                .disableAutocorrection(true)
                .padding(10)
                .shadow(color: .blue, radius: 10)
                .cornerRadius(10)
                .font(.custom("Arial", size: 26))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .minimumScaleFactor(1)
                .lineLimit(nil)
                .frame(maxWidth: 350)
                .onAppear {
                    // Keyboard dismissal when the view appears
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
            // Show alert - in an error or invalid input
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Function to validate user input using a regex pattern
    private func isinputvalid(input: String) -> Bool {
        let regex = "^[a-zA-Z0-9,\\s]+$"
        let inputTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return inputTest.evaluate(with: input)
    }
}

