import SwiftUI

struct EventRowView: View {
  let event: LCGeocodedEvent
  let group: LCUserGroup?
  static let taskDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM d, h:mm a"
    return formatter
  }()

  var iconImage: some View {
    return self.group?.group.icon.flatMap { icon in
      guard case let .image(name) = icon else {
        return nil
      }
      return name
    }.map {
      Image($0).renderingMode(.template).resizable().scaledToFit()
    }
  }

  var iconText: some View {
    return self.group?.group.icon.flatMap { (icon) -> String? in
      guard case let .text(string) = icon else {
        return nil
      }
      return string
    }.map {
      Text($0).font(.system(size: 16.0, weight: .black))
    }
  }

  var icon: some View {
    ZStack {
      iconImage
      iconText
    }
  }

  var groupView: some View {
    self.group.map {
      group in
      HStack {
        icon
        Text(group.group.name)
          .font(.caption)
      }.padding(.bottom, -8.0)
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      groupView.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 8.0, idealHeight: nil, maxHeight: 12.0, alignment: .leading)

      Text(self.event.event.name).fontWeight(.bold).lineLimit(1).allowsTightening(true)

      HStack {
        Text("\(self.event.event.date, formatter: Self.taskDateFormat)").font(.caption).lineLimit(1)
        Spacer()
        Text(self.event.event.location?.venue ?? "").font(.caption).lineLimit(1)
      }
    }
    .opacity(self.event.event.date < Date() ? 0.5 : 1.0)
  }
}

struct EventRowView_Previews: PreviewProvider {
  static var previews: some View {
    let event = LCEvent(
      id: UUID().uuidString,
      location: LCLocation(venue: "New Place", address: ""),
      description: "Talk about stuff", name: "How to Get Started with Swift in 2020",
      date: Date(),
      url: URL(string: "https://google.com")!,
      group: "meetups"
    )

    let geoEvent = LCGeocodedEvent(event: event, coordinate: nil)

    let userGroup = LCUserGroup(group: LCGroup(id: "meetups", name: "Meetups", url: URL(string: "https://google.com")!, description: "test", schedule: "every sunday", icon: .image("fas.coffee")), rank: 20.0, isFavorite: false)
    return EventRowView(event: geoEvent, group: userGroup).previewLayout(PreviewLayout.fixed(width: 300, height: 60))
  }
}
