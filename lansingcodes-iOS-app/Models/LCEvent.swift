import Firebase
import Foundation

struct LCLocation {
  let venue: String
  let address: String
}

struct LCEvent: DataModel, Identifiable {
  static let queryName: String = "events"

  let id: String
  let location: LCLocation
  let description: String
  let name: String
  let date: Date
  let url: URL
  let group: String

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
    guard let venue = document.data()["venue"] as? String else {
      throw MissingDocumentFieldError(fieldName: "venue")
    }
    guard let address = document.data()["address"] as? String else {
      throw MissingDocumentFieldError(fieldName: "address")
    }
    self.name = name
    self.url = url
    self.description = description
    self.group = group
    date = Date(timeIntervalSince1970: startTime)
    location = LCLocation(venue: venue, address: address)
  }
}
