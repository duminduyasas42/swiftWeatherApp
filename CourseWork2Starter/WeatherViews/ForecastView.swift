//
//  Forecast.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct ForecastView: View {
    // Injects the model data object
    @EnvironmentObject var modelData: ModelData
    // The location string displayed on the view
    @State var locationString: String = "No location"
    
    var body: some View {
        
        ZStack {
       
            Image("background2")
                .resizable()
                .ignoresSafeArea()
            
            VStack{
                // The location text, which displays the user location
                Text("\(modelData.userLocation)")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                // The list of daily weather data
                List{
                    ForEach(modelData.forecast!.daily) { day in
                        DailyView(day: day)
                    }
                }
                .opacity(0.8)
            }
        }
       
    }
}

struct Forecast_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView().environmentObject(ModelData())
    }
}
