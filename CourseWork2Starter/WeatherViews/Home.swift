//
//  HomeView.swift
//  CWK2_23_GL
//
//  Created by GirishALukka on 10/03/2023.
//

import SwiftUI
import Foundation
import CoreLocation

struct Home: View {
    @EnvironmentObject var modelData: ModelData
    // State variables to manage search view and user location
    @State var isSearchOpen: Bool = false
    @State var userLocation: String = ""

    var body: some View {
        // Main ZStack containing the background image and ScrollView
        ZStack {
            // Background image
            Image("background2")
                .resizable()
                .ignoresSafeArea()

            // ScrollView containing  information
            ScrollView {
                VStack(spacing: 20) {
                    // Button to - search view
                    Button {
                        self.isSearchOpen.toggle()
                    } label: {
                        Text("Change Location")
                            .bold()
                            .font(.system(size: 30))
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 72)
                    // Present SearchView in a sheet
                    .sheet(isPresented: $isSearchOpen) {
                        SearchView(isSearchOpen: $isSearchOpen, userLocation: $userLocation)
                    }

                    // Displaying user location, time, temperature, humidity, pressure, and weather description
                    Text(userLocation)
                        .font(.title)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 0.5)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(formatteddatetime(from: Date(timeIntervalSince1970: TimeInterval(((Int)(modelData.forecast?.current.dt ?? 0))))))
                        .padding(.bottom, 10)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 1)
                    
                    Spacer()

                    Text("Temp: \((Int)(modelData.forecast!.current.temp))ºC")
                        .padding(.top, 100)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .font(.title2)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 0.5)

                    Text("Humidity: \((Int)(modelData.forecast!.current.humidity))%")
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .font(.title2)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 0.5)

                    Text("Pressure: \((Int)(modelData.forecast!.current.pressure)) hPa")
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .font(.title2)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 0.5)

                    // Displaying weather icon and description
                    HStack {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(modelData.forecast!.current.weather[0].icon)@2x.png"))

                        Text("\(modelData.forecast!.current.weather[0].weatherDescription.rawValue)")
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                }
                // Get user location from latitude and longitude
                .onAppear {
                    Task.init {
                        self.userLocation = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
                    }
                }
            }
        }
    }

    // Function to format the time from a Date object
    func formatteddatetime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy 'at' h a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }
}

