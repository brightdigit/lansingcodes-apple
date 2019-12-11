import SwiftUI

struct EventRowView: View {
  let event: LCEvent
  let group: LCGroup?
  static let taskDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM d, h:mm a"
    return formatter
  }()

  var iconImage: some View {
    return self.group?.icon.flatMap { icon in
      guard case let .image(name) = icon else {
        return nil
      }
      return name
    }.map {
      Image($0).renderingMode(.template)
    }
  }

  var iconText: some View {
    return self.group?.icon.flatMap { (icon) -> String? in
      guard case let .text(string) = icon else {
        return nil
      }
      return string
    }.map {
      Text($0).font(.system(size: 24, weight: .black))
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
        Text(group.name)
      }.frame(height: 10.0)
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      groupView
      Text(self.event.name).fontWeight(.bold).lineLimit(1)

      HStack {
        Text("\(self.event.date, formatter: Self.taskDateFormat)").font(.caption).lineLimit(1)
        Spacer()
        Text(self.event.location?.venue ?? "").font(.caption).lineLimit(1)
      }
    }
    .opacity(self.event.date < Date() ? 0.5 : 1.0)
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

    return EventRowView(event: event, group: LCGroup(id: "meetups", name: "Meetups", url: URL(string: "https://google.com")!, description: "test", schedule: "every sunday", icon: .image("fas.coffee"))).previewLayout(PreviewLayout.fixed(width: 300, height: 50))
  }
}
