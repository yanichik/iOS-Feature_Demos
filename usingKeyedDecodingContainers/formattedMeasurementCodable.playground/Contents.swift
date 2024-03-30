import UIKit

// let weatherJSON = """
//    "location": "San Francisco",
//    "wind"
// """

struct Weather: Codable {
    var location: String
    var wind: Measurement<UnitSpeed>?
    var windDirection: Direction
    var temperature: Measurement<UnitTemperature>?
    var humidity: Int

    enum Direction: Int, Codable {
        case north
        case south
        case east
        case west
    }

    enum CodingKeys: String, CodingKey {
        case location
        case wind
        case windDirection
        case temperature
        case humidity
    }

    init(location: String, windDirection: Weather.Direction, humidity: Int, wind: Measurement<UnitSpeed>?, temperature: Measurement<UnitTemperature>?) {
        self.location = location
        self.wind = wind
        self.windDirection = windDirection
        self.temperature = temperature
        self.humidity = humidity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        location = try container.decode(String.self, forKey: .location)
        windDirection = try container.decode(Direction.self, forKey: .windDirection)
        humidity = try container.decode(Int.self, forKey: .humidity)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumIntegerDigits = 1

        if let windSpeedValue = try? container.decode(Double.self, forKey: .wind) {
            let speedMeasurement = Measurement(value: windSpeedValue, unit: UnitSpeed.metersPerSecond)
            wind = speedMeasurement
        }

        if let tempValue = try? container.decode(Double.self, forKey: .temperature) {
            let tempMeasurement = Measurement(value: tempValue, unit: UnitTemperature.celsius)
            temperature = tempMeasurement
        }
    }
}

let sfWeather = Weather(location: "San Francisco", windDirection: .north, humidity: 80, wind: Measurement(value: 10, unit: .metersPerSecond), temperature: Measurement(value: 20, unit: .celsius))

let encoder = JSONEncoder()
let decoder = JSONDecoder()
do {
    let sfWeatherData = try encoder.encode(sfWeather)
    print(sfWeatherData)
    let sfWeatherJSON = try decoder.decode(Weather.self, from: sfWeatherData)
    print(sfWeatherJSON)
} catch {
    print("error: \(error)")
}
