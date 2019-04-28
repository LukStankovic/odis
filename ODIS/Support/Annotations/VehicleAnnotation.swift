import MapKit

class VehicleAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var vehicleType: String!
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D, lineNumber: Int?) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location

        if lineNumber ?? 1000 <= 19 {
            self.vehicleType = "tram"
        } else if lineNumber ?? 1000 > 100 && lineNumber ?? 1000 <= 113 {
            self.vehicleType = "tbus"
        } else {
            self.vehicleType = "bus"
        }
    }
}
