//
//  TrolleyBusAnnotation.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 30/04/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import MapKit

class TrolleyBusAnnotation: VehicleAnnotation {
    override init(vehicle: VehicleTO) {
        super.init(vehicle: vehicle)
        image = UIImage(named: VehicleTypes.tbus.rawValue)
        icon = VehicleTypesIcons.tbus.rawValue
    }
}
