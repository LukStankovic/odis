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

    @IBAction func refreshVehiclesBtn(_ sender: UIButton) {
        loadVehiclesIntoMap()
    }
    
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
                let vehicleLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(vehicle.locationX), longitude: CLLocationDegrees(vehicle.locationY))
                
                var vehicleInfo = "Výchozí: " + vehicle.startStop + "\n"
                vehicleInfo += "Cílová: " + vehicle.finalStop + "\n"
                vehicleInfo += "Poslední: " + vehicle.lastStop + "\n"
                vehicleInfo += "Následující: " + vehicle.nextStop + "\n"
                
                let annotation = VehicleAnnotation(pinTitle: "Linka " + vehicle.line, pinSubTitle: vehicleInfo, location: vehicleLocation, lineNumber: Int(vehicle.line))
            
                self.map.addAnnotation(annotation)
                self.map.delegate = self
            }
            
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.canShowCallout = true
        let vehicleAnnotation = annotation as! VehicleAnnotation
        annotationView.image = UIImage(named: vehicleAnnotation.vehicleType)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 400))
        label.text = annotation.subtitle ?? ""
        
        label.numberOfLines = 0
        annotationView.detailCalloutAccessoryView = label;

        let width = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 700)
        label.addConstraint(width)
        
        
        let height = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        label.addConstraint(height)
        
        
        return annotationView
    }

}
