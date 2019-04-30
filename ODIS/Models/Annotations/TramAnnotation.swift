//
//  TramAnnotation.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 30/04/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import MapKit

class TramAnnotation: VehicleAnnotation {
    override init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        super.init(pinTitle: pinTitle, pinSubTitle: pinSubTitle, location: location)
        annotationImage = UIImage(named: VehicleTypes.tram.rawValue)
        annotationIcon = VehicleTypesIcons.tram.rawValue
    }
}
