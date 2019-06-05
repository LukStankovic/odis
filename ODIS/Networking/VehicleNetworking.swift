//
//  VehicleNetworking.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 28/04/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import Foundation

struct VehicleNetworking {
    
    func getVehicles(completion: @escaping (_ result: Vehicles?, _ error: Error?) -> Void) {
        let url = URL(string: "https://vydaje.stankoviclukas.cz/odis/vehicles/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = "client=4ba498e3617fbc53bfcabe8574b66f851f97a99a1b34253b12ca4e0685c0f3e4".data(using: String.Encoding.ascii, allowLossyConversion: false)
        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")

                return completion(nil, error)
            }
            let vehicles = try? JSONDecoder().decode(Vehicles.self, from: data)

            return completion(vehicles, nil)
        }
        task.resume()
    }
}
