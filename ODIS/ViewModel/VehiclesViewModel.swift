//
//  VehiclesViewModel.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 08/06/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import Foundation

class VehiclesViewModel {
    
    var vehicles : [VehicleTO] = []
    
    var error: Error?
    
    init() {
        refreshVehicles()
    }
    
    func refreshVehicles() {
        VehicleNetworking.getVehicles { (vehicles, error) in
            if error != nil {
                self.error = error
            }
            
            self.vehicles = vehicles?.vehicles ?? []
        }
    }
    
}
