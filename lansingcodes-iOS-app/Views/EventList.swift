import SwiftUI

struct EventList: View {
  @EnvironmentObject var dataset: Dataset
  let groupId: String?

  var events: Result<[LCEvent], Error>? {
    dataset.events.map { result in
      result.map { events in
        events.filter {
          $0.group == groupId || groupId == nil
        }.sorted { (lhs, rhs) -> Bool in
          let lti = lhs.date.timeIntervalSinceNow
          let rti = rhs.date.timeIntervalSinceNow
          if lti > 0, rti > 0 {
            return rti > lti
          } else {
            return rti < lti
          }
        }
      }
    }
  }

  var body: some View {
    ZStack {
      list
      error
      busy
    }
  }

  var list: some View {
    let events = self.events.flatMap { try? $0.get() } ?? [LCEvent]()
    return List(events) { event in
      EventRowView(event: event)
    }
  }

  var busy: some View {
    Group {
      if events == nil {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
      }
    }
  }

  var error: some View {
    Text(events?.error?.localizedDescription ?? "")
  }
}

struct EventList_Previews: PreviewProvider {
  static var previews: some View {
    let events = [
      LCEvent(
        id: UUID().uuidString,
        location: LCLocation(venue: "New Place", address: ""),
        description: "Talk about stuff", name: "JS 101",
        date: Date(),
        url: URL(string: "https://google.com")!,
        group: "meetups"
      ),
      LCEvent(
        id: UUID().uuidString,
        location: LCLocation(venue: "New Place", address: ""),
        description: "Talk about stuff", name: "JS 101",
        date: Date(),
        url: URL(string: "https://google.com")!,
        group: "meetups"
      ),
    ]
    let mockDataset = MockDatastore(groups: [LCGroup](), events: events)
    return EventList(groupId: nil).previewLayout(PreviewLayout.fixed(width: 300, height: 50)).environmentObject(Dataset(db: mockDataset))
  }
}
