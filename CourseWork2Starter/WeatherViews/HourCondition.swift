//
//  HourCondition.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct HourCondition: View {
    var current : Current  // current hourly weather condition

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // display formatted time
                Text(formattedTime(from: Date(timeIntervalSince1970: TimeInterval(((Int)(current.dt ))))))
                    .frame(maxWidth: .infinity, alignment: .center) // Center the weekday text
                
                // display formatted weekday
                Text(Date(timeIntervalSince1970: TimeInterval(((Int)(current.dt))))
                    .formatted(.dateTime.weekday()))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            //  weather icon
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(current.weather[0].icon)@2x.png"))
            
            // display temperature
            Text("\(Int(current.temp))ºC")
            
            // display weather condition
            Text("\(current.weather[0].weatherDescription.rawValue)")
        }.padding()
    }
    
    // function to format time from a given date
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }

}

struct HourCondition_Previews: PreviewProvider {
    static var hourly = ModelData().forecast!.hourly
    
    static var previews: some View {
        HourCondition(current: hourly[0])
    }
}
