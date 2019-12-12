import CoreLocation
import Foundation

struct LCLocation {
  let venue: String
  let address: String
  let placemark: Result<CLPlacemark, Error>?

  init(venue: String, address: String, placemark: Result<CLPlacemark, Error>? = nil) {
    self.venue = venue
    self.address = address
    self.placemark = placemark
  }
}
