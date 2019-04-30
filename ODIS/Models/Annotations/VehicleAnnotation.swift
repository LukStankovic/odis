import MapKit

class VehicleAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var annotationImage: UIImage!
    var annotationIcon: String!

    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
    
}
