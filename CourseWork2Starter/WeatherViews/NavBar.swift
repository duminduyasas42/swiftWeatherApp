//
//  NavBar.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct NavBar: View {
    @StateObject private var modelData = ModelData()
       @StateObject private var airPollution = AirModelData()
    
    var body: some View {
        TabView{
            Home()
                .tabItem{
                    
                    Label("City", systemImage: "magnifyingglass")
                }
      
            
            CurrentWeatherView()
                .tabItem {
                    
                    Label("WeatherNow", systemImage: "sun.max.fill")
                }
            
            HourlyView()
                .tabItem{
                    
                    Label("Houly Summary", systemImage: "clock.fill")
                }
            ForecastView()
                .tabItem {
                    
                    Label("Forcast", systemImage: "calendar")
                }
            PollutionView()
                .tabItem {
                    
                    Label("Pollution", systemImage: "aqi.high")
                }
        }.environmentObject(modelData)
            .environmentObject(airPollution)
            .onAppear {
            UITabBar.appearance().isTranslucent = false
        }
        
    }
    
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar()
    }
}
