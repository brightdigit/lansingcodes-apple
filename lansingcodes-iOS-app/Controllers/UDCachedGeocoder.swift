import Foundation

public struct UDCachedGeocoder: Geocoder {
  let geocoder: Geocoder
  let defaults: UserDefaults
}
