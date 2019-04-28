//
//  FirstViewController.swift
//  ODIS Mapa
//
//  Created by Lukáš Stankovič on 31/03/2019.
//  Copyright © 2019 Lukáš Stankovič. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VehiclesMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // Map
    @IBOutlet weak var map: MKMapView!

    
    let manager = CLLocationManager()

    let vehicleNetworing = VehicleNetworking()
    
    var userLocation: CLLocationCoordinate2D?
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // TODO after location init
        if userLocation != nil {
            let span: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region: MKCoordinateRegion = MKCoordinateRegion.init(center: userLocation!, span: span)
            map.setRegion(region, animated: true)
        }
        
        loadVehiclesIntoMap()
        var vehiclesUpdateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(VehiclesMapViewController.loadVehiclesIntoMap), userInfo: nil, repeats: true)

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]

        userLocation = CLLocationCoordinate2D.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        map.showsUserLocation = true
    }
    
    
    @objc func loadVehiclesIntoMap() {
        vehicleNetworing.getVehicles() { (vehicles, error) in
            if error != nil {
                print("Error")
            }
            
            guard let vehicles = vehicles else { return }
            
            DispatchQueue.main.async {
                self.map.removeAnnotations(self.map.annotations)
            }
            
            for vehicle in vehicles.vehicles {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(vehicle.locationX), longitude: CLLocationDegrees(vehicle.locationY))
                annotation.title = vehicle.line
                
                self.map.addAnnotation(annotation)
            }
            
        }
    }

}
