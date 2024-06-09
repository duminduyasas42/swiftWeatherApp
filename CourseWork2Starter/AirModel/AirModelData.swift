//
//  PollutionView.swift
//  Coursework2
//
//  Created by GirishALukka on 30/12/2022.
//


import Foundation
import Combine

//  as an observable object conforming to the Decodable protocol
typealias AirPollution = AirModelData

class AirModelData: ObservableObject, Decodable {
    // Define two @Published variables for the coordinate data and the list of pollution data
    @Published var coord: Coord
    @Published var list: [AirPollutionDataList]

    // initializer to set default values
    init() {
        coord = Coord(lon: 0.0, lat: 0.0)
        list = []
    }

    // initializer to decode the JSON data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coord = try container.decode(Coord.self, forKey: .coord)
        list = try container.decode([AirPollutionDataList].self, forKey: .list)
    }

    // Define an enum to map the keys
    private enum CodingKeys: String, CodingKey {
        case coord, list
    }
}

// struct for coordinate data
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// struct for air pollution data
struct AirPollutionDataList: Codable {
    let main: AirPollutionMain
    let components: Component
    let dt: Int
}

// struct for main air pollution data
struct AirPollutionMain: Codable {
    let aqi: Int
}

// struct for individual pollutant components
struct Component: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double
}
