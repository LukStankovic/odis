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
    @IBOutlet weak var map: MKMapView! {
        didSet {
            let userTrackingButton = MKUserTrackingButton(mapView: map)
            userTrackingButton.layer.position = CGPoint(x: 30, y: 50)
            userTrackingButton.backgroundColor = UIColor.white
            userTrackingButton.layer.cornerRadius = 5
            userTrackingButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            userTrackingButton.layer.shadowRadius = 3
            userTrackingButton.layer.shadowOpacity = 0.5
            map.delegate = self
            map.showsUserLocation = true
            map.setUserTrackingMode(.follow, animated: true)
            map.addSubview(userTrackingButton)
        }
    }

    @IBAction func refreshVehiclesBtn(_ sender: UIButton) {
        loadVehiclesIntoMap()
    }

    let manager = CLLocationManager()

    let vehicleNetworing = VehicleNetworking()

    var userLocation: CLLocationCoordinate2D?

    var timer: Timer!

    let feedbackGenerator = UISelectionFeedbackGenerator()

    lazy var bulletinManager: BLTNItemManager = {
        let introPage = BulletinDataSource.makeVehiclePage(vehicle: nil)
        return BLTNItemManager(rootItem: introPage)
    }()

    @IBOutlet weak var refreshButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshButton.layer.cornerRadius = 5
        refreshButton.layer.masksToBounds = true

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

            DispatchQueue.main.async {
                for vehicle in vehicles.vehicles {
                    let annotation = AnnotationFactory.shared().getAnnotation(vehicle: vehicle)
                    self.map.addAnnotation(annotation)
                    self.map.delegate = self
                }
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
        annotationView.image = vehicleAnnotation.image

        let annotationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 105, height: 30))
        annotationLabel.numberOfLines = 1
        annotationLabel.textAlignment = .center
        annotationLabel.text =  annotation.title!!
        annotationView.addSubview(annotationLabel)

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect annotationView: MKAnnotationView) {
        if annotationView.annotation is MKUserLocation {
            return
        }
        feedbackGenerator.selectionChanged()

        let vehicleAnnotation = annotationView.annotation as! VehicleAnnotation
        let vehiclePage = BulletinDataSource.makeVehiclePage(vehicle: vehicleAnnotation.vehicle)
        bulletinManager = BLTNItemManager(rootItem: vehiclePage)
        bulletinManager.showBulletin(above: self)

    }

}
