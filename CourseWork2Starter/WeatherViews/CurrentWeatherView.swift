//
//  Conditions.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct CurrentWeatherView: View {
    // Inject ModelData object to get the forecast data
    @EnvironmentObject var modelData: ModelData
    // User location string
    @State  var userLocation: String = ""
    // String to display current location
    @State var locationString: String = "No location"
    
    var body: some View {
        // Main ZStack containing the background image and ScrollView
        ZStack {
            
            Image("background2")
                .resizable()
                .ignoresSafeArea()
            // ScrollView containing all the information
            VStack {
                // Display user location
                Text(userLocation)
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
                
                VStack{
                    
                    // Temperature Info
                    VStack {
                        Text("\((Int)(modelData.forecast!.current.temp))ºC")
                            .padding()
                            .font(.largeTitle)
                        
                        // Display current weather icon and description
                        HStack {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(modelData.forecast!.current.weather[0].icon)@2x.png"))
                            Text(modelData.forecast!.current.weather[0].weatherDescription.rawValue.capitalized)
                        }
                        
                      
                        VStack {
                            HStack {
                                // Display high and low temperatures for the day
                                Text("H: \((Int)(modelData.forecast!.daily[0].temp.max))ºC")
                                    .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 20))
                                Text("Low: \((Int)(modelData.forecast!.daily[0].temp.min))ºC")
                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 50))
                            }
                            .padding(.bottom, 10)
                            //  , as well as "feels like" temperature
                            Text("Feels Like: \((Int)(modelData.forecast!.current.feelsLike))ºC")
                        }
                        
                        // wind speed and direction
                        HStack{
                            Text("Wind Speed: \((Int)(modelData.forecast!.current.windSpeed))m/s")
                            Spacer()
                            Text("Direction:\( convertDegToCardinal(deg: modelData.forecast!.current.windDeg))")
                        }
                        .padding()
                        
                        // humidity and pressure
                        HStack{
                            Text("Humidity: \((Int)(modelData.forecast!.current.humidity))%")
                                .foregroundColor(.black)
                            Spacer()
                            Text("Presure: \((Int)(modelData.forecast!.current.pressure))hPg")
                        }
                        .padding()
                        
                        // sunrise and sunset times
                        HStack(spacing: 30) {
                            HStack{
                                Image(systemName: "sunrise.fill")
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.yellow)
                                Text(formattedtimes(from: Date(timeIntervalSince1970: TimeInterval(((Int)(modelData.forecast?.current.sunrise ?? 0))))))
                            }
                            HStack{
                                Image(systemName: "sunset.fill")
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(.yellow)
                                Text(formattedtimes(from: Date(timeIntervalSince1970: TimeInterval(((Int)(modelData.forecast?.current.sunset ?? 0))))))
                            }
                        }

                    }.padding()
                }
                
            }
            .foregroundColor(.black)
            .shadow(color: .black,  radius: 0.5)
            
        }
        .onAppear {
            Task.init {
                self.userLocation = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
                
            }
            
        }
        
    }
    

    func formattedtimes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }

}

struct Conditions_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
            .environmentObject(ModelData())
    }
}
