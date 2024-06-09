//
//  PollutionView.swift
//  Coursework2
//
//  Created by GirishALukka on 30/12/2022.
//
import SwiftUI

struct PollutionView: View {
    @EnvironmentObject var modelData: ModelData
//    @EnvironmentObject var airPollution: AirModelData

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("\(modelData.userLocation)")
                    .font(.title)
                    .foregroundColor(.black)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)

                Text("\((Int)(modelData.forecast!.current.temp))ºC")
                    .padding()
                    .font(.largeTitle)

                HStack {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(modelData.forecast!.current.weather[0].icon)@2x.png"))
                        .frame(width: 60, height: 60)
                    Text(modelData.forecast!.current.weather[0].weatherDescription.rawValue.capitalized)
                }

                VStack {
                    HStack {
                        Text("H: \((Int)(modelData.forecast!.daily[0].temp.max))ºC")
                            .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 20))
                        Text("Low: \((Int)(modelData.forecast!.daily[0].temp.min))ºC")
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 50))
                    }
                    .padding(.bottom, 10)

                    Text("Feels Like: \((Int)(modelData.forecast!.current.feelsLike))ºC")
                }

                Text("Air Quality Data:")
                    .font(.title)

                HStack {
                    VStack {
                        Image("so2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Text("\(String(format: "%.2f", modelData.airPollution?.list[0].components.so2 ?? 0.0))")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)

                    VStack {
                        Image("no")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Text("\(String(format: "%.2f", modelData.airPollution?.list[0].components.no2 ?? 0.0))")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)

                    VStack {
                        Image("voc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Text("\(String(format: "%.2f", modelData.airPollution?.list[0].components.co ?? 0.0))")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)

                    VStack {
                        Image("pm")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Text("\(String(format: "%.2f", modelData.airPollution?.list[0].components.pm10 ?? 0.0))")
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 5)
            }
            .shadow(color: .black, radius: 0.5)
        }
        .onAppear {
            Task {
                do {
                    if let latitude = modelData.forecast?.lat, let longitude = modelData.forecast?.lon {
                        try await modelData.loadData(lat: latitude, lon: longitude)
                        try await modelData.loadAirData()
                    } else {
                        print("Error: Forecast latitude and longitude are not available.")
                    }
                } catch {
                    print(error)
                }
            }
        }

    }
}

