import Foundation

protocol CachedGeocoder {
  func queue(addressString: String)

  func publisher()
}

extension CachedGeocoder {
  func queue(addressStrings: [String]) {
    for addressString in addressStrings {
      queue(addressString: addressString)
    }
  }
}
