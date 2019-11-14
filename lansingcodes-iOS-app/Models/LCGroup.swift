import Firebase
import Foundation

struct LCGroup: Identifiable {
  let id: String
  let name: String
  let url: URL
  let description: String
  let attributedDescription: NSAttributedString?
  let schedule: String
  let icon: LCIcon?
  /*
   "name": Web,
   "schedule": 2nd Wednesday,
   "description": Share your latest project,
      talk about tools you're using, network, trade advice, or just chat about the web.,
   "url": https://www.meetup.com/lansingweb/,
   "slug": lansingweb,
   "iconName": html5,
   "iconSet": fab
   */
  init(id: String,
       name: String,
       url: URL,
       description: String,
       schedule: String,
       icon: LCIcon? = nil) {
    self.id = id
    self.name = name
    self.url = url
    self.description = description
    attributedDescription = self.description.htmlToAttributedString
    self.icon = icon
    self.schedule = schedule
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
    guard let schedule = document.data()["schedule"] as? String else {
      throw MissingDocumentFieldError(fieldName: "schedule")
    }
    self.name = name
    self.url = url
    self.description = description
    self.schedule = schedule
    attributedDescription = self.description.htmlToAttributedString
    if let iconSet = document.data()["iconSet"] as? String, let iconName = document.data()["iconName"] as? String {
      let name: String
      let components = iconName.components(separatedBy: "-")
      if iconSet == "mfizz", components.count == 2, let nameOpt = components.last {
        name = nameOpt
      } else {
        name = iconName
      }
      icon = .image([iconSet, name].joined(separator: "."))
    } else if let iconText = document.data()["iconText"] as? String {
      icon = .text(iconText)
    } else {
      icon = nil
    }
  }
}
