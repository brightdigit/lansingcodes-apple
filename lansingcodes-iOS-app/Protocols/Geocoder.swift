import CoreLocation
import Foundation
typealias Degrees = CLLocationDegrees

protocol Coordinate {
  var latitude: Degrees { get }
  var longitude: Degrees { get }
  func asDictionary() -> Any
}

extension CLLocationCoordinate2D: Coordinate {}
protocol Geocoder {
  func geocodeAddressString(_ addressString: String, completionHandler: @escaping (Result<Coordinate, Error>) -> Void)
}

extension CLGeocoder: Geocoder {
  func geocodeAddressString(_ addressString: String, completionHandler: @escaping (Result<Coordinate, Error>) -> Void) {
    geocodeAddressString(addressString) { placemarks, error in
      let result: Result<Coordinate, Error> = Result(placemarks, withError: error, defaultError: NoDataError()).flatMap { placemarks in
        if let coordinate = placemarks.first?.location?.coordinate {
          return .success(coordinate)
        } else {
          return .failure(NoDataError())
        }
      }
      completionHandler(result)
    }
  }
}
