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
import BLTNBoard

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
    
    let feedbackGenerator = UISelectionFeedbackGenerator()


    lazy var bulletinManager: BLTNItemManager = {
        let introPage = BulletinDataSource.makeVehiclePage(title: "Linka", subTitle: "Asasd")
        return BLTNItemManager(rootItem: introPage)
    }()

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
        vehicleNetworing.getVehicles { (vehicles, error) in
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

                let annotation = AnnotationFactory.shared().getAnnotation(pinTitle: vehicle.line, pinSubTitle: vehicleInfo, location: vehicleLocation, vehicleLineNumber: Int(vehicle.line) ?? 0)
                
                self.map.addAnnotation(annotation)
                self.map.delegate = self
            }

        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "vehicle")
        annotationView.canShowCallout = false

        let vehicleAnnotation = annotation as! VehicleAnnotation
        annotationView.image = vehicleAnnotation.annotationImage

        let annotationLabel = UILabel(frame: CGRect(x: -24, y: 55, width: 105, height: 30))
        annotationLabel.numberOfLines = 1
        annotationLabel.textAlignment = .center
        annotationLabel.text =  annotation.title!!
        annotationView.addSubview(annotationLabel)
       
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        feedbackGenerator.selectionChanged()
        let vehiclePage = BulletinDataSource.makeVehiclePage(title: annotationView.annotation?.title ?? "", subTitle: annotationView.annotation?.subtitle ?? "")
        bulletinManager = BLTNItemManager(rootItem: vehiclePage)
        bulletinManager.showBulletin(above: self)
    }
    
}
