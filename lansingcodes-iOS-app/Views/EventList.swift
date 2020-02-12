import SwiftUI

struct EventList: View {
  @EnvironmentObject var dataset: LCDataObject
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

  var groups: Result<[String: LCGroup], Error>? {
    dataset.groups.map {
      result in
      result.map {
        [String: [LCGroup]](grouping: $0, by: {
          $0.id
        }).compactMapValues { $0.first }
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
      NavigationLink(destination: EventItemView(event: event, group: self.groupFor(event, true))) {
        EventRowView(event: event, group: self.groupFor(event))
      }
    }
  }

  func groupFor(_ event: LCEvent, _ always: Bool = false) -> LCGroup? {
    guard groupId == nil || always else {
      return nil
    }
    guard let result = self.groups else {
      return nil
    }
    guard let groups = try? result.get() else {
      return nil
    }
    return groups[event.group]
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
    let groups = [
      LCGroup(id: "meetups", name: "Meetups", url: URL(string: "https://google.com")!, description: "test", schedule: "every sunday", icon: .image("fas.coffee"))
    ]
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
        description: "Talk about stuff", name: "Lean Coffee Code",
        date: Date(),
        url: URL(string: "https://google.com")!,
        group: "meetups"
      )
    ]
    let mockDataset = MockDatastore(groups: [LCGroup](), events: events)
    return EventList(groupId: nil).previewLayout(PreviewLayout.fixed(width: 300, height: 50)).environmentObject(LCDataObject(store: mockDataset))
  }
}
