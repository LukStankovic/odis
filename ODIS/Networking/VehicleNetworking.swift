//
//  VehicleNetworking.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 28/04/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import Foundation

struct VehicleNetworking {
    
    private enum Constants {
        static let apiUrl = URL(string: "https://api.stankoviclukas.cz/odis/vehicles/")!
    }
    
    static func getVehicles(completion: @escaping (_ result: VehiclesTO?, _ error: Error?) -> Void) {
        var request = URLRequest(url: Constants.apiUrl)
        request.httpMethod = "POST"
        // todo keychain
        let data = "client=4ba498e3617fbc53bfcabe8574b66f851f97a99a1b34253b12ca4e0685c0f3e4".data(using: String.Encoding.ascii, allowLossyConversion: false)
        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")

                return completion(nil, error)
            }
            let vehicles = try? JSONDecoder().decode(VehiclesTO.self, from: data)

            return completion(vehicles, nil)
        }
        task.resume()
    }
}
