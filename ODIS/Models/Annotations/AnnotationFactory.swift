//
//  AnnotationFactory.swift
//  ODIS
//
//  Created by Lukáš Stankovič on 30/04/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import MapKit

class AnnotationFactory {

    private static var annotationFactory = AnnotationFactory()

    class func shared() -> AnnotationFactory {
        return annotationFactory
    }

    func getAnnotation(vehicle: Vehicle) -> VehicleAnnotation {
        let vehicleLine = Int(vehicle.line) ?? 0
        
        if vehicleLine <= 19 && !vehicle.line.contains("MHD") {
            return TramAnnotation(vehicle: vehicle)
        } else if vehicleLine > 100 && vehicleLine <= 113 {
            return TrolleyBusAnnotation(vehicle: vehicle)
        } else {
            return BusAnnotation(vehicle: vehicle)
        }
    }

}
