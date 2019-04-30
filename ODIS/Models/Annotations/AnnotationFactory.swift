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

    func getAnnotation(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D, vehicleLineNumber: Int) -> VehicleAnnotation {
        if vehicleLineNumber <= 19 {
           return TramAnnotation(pinTitle: pinTitle, pinSubTitle: pinSubTitle, location: location)
        } else if vehicleLineNumber > 100 && vehicleLineNumber <= 113 {
            return TrolleyBusAnnotation(pinTitle: pinTitle, pinSubTitle: pinSubTitle, location: location)
        } else {
            return BusAnnotation(pinTitle: pinTitle, pinSubTitle: pinSubTitle, location: location)
        }
    }

}
