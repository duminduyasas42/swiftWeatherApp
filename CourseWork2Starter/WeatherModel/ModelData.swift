import Foundation


class ModelData: ObservableObject {
    
    @Published var forecast: Forecast?
    @Published  var userLocation: String = ""
    @Published  var airPollution: AirModelData?
    
    init() {
        self.forecast = load("london.json")
    }
    

    func loadData(lat: Double, lon: Double) async throws {
        let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=9de38b54ba5835da9aee0b58ef533894")
        let session = URLSession(configuration: .default)

        let (data, _) = try await session.data(from: url!)

        do {
            let forecastData = try JSONDecoder().decode(Forecast.self, from: data)
            DispatchQueue.main.async {
                self.forecast = forecastData
            }

            // Fetch location string from latitude and longitude
            let locationString =  await getLocFromLatLong(lat: lat, lon: lon)
            DispatchQueue.main.async {
                self.userLocation = locationString
            }
        } catch {
            throw error
        }
    }


    
    func load<Forecast: Decodable>(_ filename: String) -> Forecast {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Forecast.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(Forecast.self):\n\(error)")
        }
    }
    
    //
    func loadAirData() async throws {
        guard let lat = forecast?.lat, let lon = forecast?.lon else {
            fatalError("Couldn't find lat and long in forecast data")
        }
        
        
        let url = URL(string:"https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&units=metric&appid=9de38b54ba5835da9aee0b58ef533894")
        
        
        let session = URLSession(configuration: .default)
        
        let (data, _) = try await session.data(from: url!)
        
        do {
            let pollutionData = try JSONDecoder().decode(AirModelData.self, from: data)
            DispatchQueue.main.async {
                self.airPollution = pollutionData
            }
        } catch {
            throw error
        }
    }



}
