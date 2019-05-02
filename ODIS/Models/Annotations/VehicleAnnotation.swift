import MapKit

class VehicleAnnotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    var image: UIImage!
    var icon: String!
    var vehicle: Vehicle!

    init(vehicle: Vehicle) {
        self.title = vehicle.line
        self.subtitle = ""
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(vehicle.locationX), longitude: CLLocationDegrees(vehicle.locationY))
        self.vehicle = vehicle
    }

}
