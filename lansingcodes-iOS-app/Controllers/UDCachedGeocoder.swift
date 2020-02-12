import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
  static func fromDictionary(_ dictionary: Any?) -> CLLocationCoordinate2D? {
    dictionary.flatMap {
      $0 as? [String: CLLocationDegrees]
    }.flatMap {
      guard let latitude = $0["latitide"], let longitude = $0["longitide"] else {
        return nil
      }
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
  }

  func asDictionary() -> Any {
    return ["latitude": self.latitude, "longitude": self.longitude]
  }
}

public struct UDCachedGeocoder: CachedGeocoder {
  func queue(addressString: String) {
    guard var dictionary = defaults.dictionary(forKey: "coordinates") else {
      return
    }

    guard CLLocationCoordinate2D.fromDictionary(dictionary[addressString]) != nil else {
      return
    }

    queue.async {
      self.geocoder.geocodeAddressString(addressString) { result in
        if let coordinate = try? result.get() {
          dictionary[addressString] = coordinate.asDictionary()
        }
      }
    }
  }

  init(geocoder: Geocoder = CLGeocoder(), defaults: UserDefaults = UserDefaults.standard, queue: DispatchQueue = DispatchQueue.global()) {
    self.geocoder = geocoder
    self.defaults = defaults
    self.queue = queue
  }

  let queue: DispatchQueue
  let geocoder: Geocoder
  let defaults: UserDefaults
}