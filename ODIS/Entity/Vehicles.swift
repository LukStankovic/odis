import Foundation

struct Vehicles: Decodable {
    let vehicles: [Vehicle]
}

struct Vehicle: Decodable {
    let line: String
    let connection: String
    let lastStop: String
    let nextStop: String
    let startStop: String
    let finalStop: String
    let lowFloor: Bool
    let vehicleNumber: String
    let delay: String
    let locationX: Float
    let locationY: Float
}
