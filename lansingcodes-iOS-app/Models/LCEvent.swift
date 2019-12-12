import CoreLocation
import Firebase
import Foundation

struct LCEvent: DataModel, Identifiable {
  static let queryName: String = "events"

  let id: String
  let location: LCLocation?
  let description: String
  let name: String
  let date: Date
  let url: URL
  let group: String

  public init(
    id: String,
    location: LCLocation,
    description: String,
    name: String,
    date: Date,
    url: URL,
    group: String
  ) {
    self.id = id
    self.location = location
    self.description = description
    self.name = name
    self.date = date
    self.url = url
    self.group = group
  }

  init(document: QueryDocumentSnapshot) throws {
    id = document.documentID
    guard let name = document.data()["name"] as? String else {
      throw MissingDocumentFieldError(fieldName: "name")
    }
    guard let url = TryConvert.fromStringOf(document.data()["url"], byConverting: { URL(string: $0) }) else {
      throw MissingDocumentFieldError(fieldName: "url")
    }
    guard let description = document.data()["description"] as? String else {
      throw MissingDocumentFieldError(fieldName: "description")
    }
    guard let group = document.data()["group"] as? String else {
      throw MissingDocumentFieldError(fieldName: "group")
    }
    guard let startTime = document.data()["startTime"] as? TimeInterval else {
      throw MissingDocumentFieldError(fieldName: "startTime")
    }
    let location: LCLocation?
    if let venue = document.data()["venue"] as? String, let address = document.data()["address"] as? String {
      location = LCLocation(venue: venue, address: address, placemark: nil)
    } else {
      location = nil
    }
    self.name = name
    self.url = url
    self.description = description
    self.group = group
    date = Date(timeIntervalSince1970: startTime / 1000)
    self.location = location
  }

  init(event: LCEvent, withGeocodingResult geocodingResult: Result<CLPlacemark, Error>) {
    id = event.id
    location = event.location.map {
      LCLocation(venue: $0.venue, address: $0.address, placemark: geocodingResult)
    }
    description = event.description
    name = event.name
    date = event.date
    url = event.url
    group = event.group
  }
}
