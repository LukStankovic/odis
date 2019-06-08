import Foundation

struct VehiclesTO: Decodable {
    let vehicles: [VehicleTO]
}

struct VehicleTO: Decodable {
    let line: String
    let connection: String
    let lastStop: String
    let nextStop: String
    let startStop: String
    let finalStop: String
    let lowFloor: Bool
    let vehicleNumber: String
    let delay: String
    let delayInSeconds: Int
    let locationX: Float
    let locationY: Float
 
}
