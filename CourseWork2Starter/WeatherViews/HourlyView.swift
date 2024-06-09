//
//  Hourly.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct HourlyView: View {
    // Access the shared ModelData instance
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        // Use GeometryReader to get the screen dimensions
        GeometryReader { geometry in
            ZStack {
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Display the user's location
                    Text("\(modelData.userLocation)")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    // List of hourly weather conditions
                    List {
                        ForEach(modelData.forecast!.hourly) { hour in
                            HourCondition(current: hour)
                        }
                    }
                    .opacity(0.7)
                }
            }
        }
    }
}

struct Hourly_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView().environmentObject(ModelData())
    }
}

