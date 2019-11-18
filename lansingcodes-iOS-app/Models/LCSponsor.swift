import Firebase
import Foundation

struct LCSponsor: DataModel, Identifiable {
  static let queryName = "sponsors"

  let id: String
  let name: String
  let description: String
  let logoUrl: URL
  let url: URL

  init(document: QueryDocumentSnapshot) throws {
    guard let name = document.data()["name"] as? String else {
      throw MissingDocumentFieldError(fieldName: "name")
    }
    guard let url = TryConvert.fromStringOf(document.data()["url"], byConverting: { URL(string: $0) }) else {
      throw MissingDocumentFieldError(fieldName: "url")
    }
    guard let description = document.data()["description"] as? String else {
      throw MissingDocumentFieldError(fieldName: "description")
    }
    guard let logoUrl = TryConvert.fromStringOf(document.data()["logoUrl"], byConverting: { URL(string: $0) }) else {
      throw MissingDocumentFieldError(fieldName: "logoUrl")
    }

    id = document.documentID
    self.name = name
    self.description = description
    self.logoUrl = logoUrl
    self.url = url
  }

  init(id: String,
       name: String,
       description: String,
       logoUrl: URL,
       url: URL) {
    self.id = id
    self.name = name
    self.description = description
    self.logoUrl = logoUrl
    self.url = url
  }
}
