//
//  DailyView.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct DailyView: View {
    var day: Daily
    
    var body: some View {
        HStack {
            // Weather Icon
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(day.weather[0].icon)@2x.png"))
            
            Spacer()
            
            VStack {
                // Weather Description
                Text("\(day.weather[0].weatherDescription.rawValue)")
                
                // Day of the Week
                Text(Date(timeIntervalSince1970: TimeInterval((Int)(day.dt)))
                     // Used .wide to get full weekday name
                    .formatted(.dateTime.day().weekday(.wide)))
            }
            
            Spacer()
            
            // High and Low Temperatures
            Text("\((Int)(day.temp.max))ºC / \((Int)(day.temp.min))ºC")
        }
        .padding()
    }
    
}

struct DailyView_Previews: PreviewProvider {
    static var day = ModelData().forecast!.daily
    
    static var previews: some View {
        DailyView(day: day[0])
    }
}
