import SwiftUI

struct EventRowView: View {
  let event: LCEvent
  static let taskDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM d"
    return formatter
  }()

  var body: some View {
    HStack {
      Text(self.event.name)
      Spacer()
      Text("\(self.event.date, formatter: Self.taskDateFormat)")
      Spacer()
      Text(self.event.location?.venue ?? "TBA")
    }.opacity(self.event.date < Date() ? 0.5 : 1.0)
  }
}

struct EventRowView_Previews: PreviewProvider {
  static var previews: some View {
    let event = LCEvent(
      id: UUID().uuidString,
      location: LCLocation(venue: "New Place", address: ""),
      description: "Talk about stuff", name: "JS 101",
      date: Date(),
      url: URL(string: "https://google.com")!,
      group: "meetups"
    )

    return EventRowView(event: event).previewLayout(PreviewLayout.fixed(width: 300, height: 50))
  }
}
