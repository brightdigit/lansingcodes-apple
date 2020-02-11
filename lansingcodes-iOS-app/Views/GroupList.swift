import SwiftUI

struct GroupList: View {
  @EnvironmentObject var dataset: Dataset
  var body: some View {
    let eventDictionary = dataset.events.flatMap {
      (try? $0.get()).map {
        [String: [LCEvent]](grouping: $0, by: { $0.group })
      }?.mapValues { events in
        min(events.map { $0.date }.max()?.timeIntervalSinceNow ?? -Double.greatestFiniteMagnitude, 0)
      }
    }

    let defaultValue = eventDictionary == nil ? 0 : -Double.greatestFiniteMagnitude

    let result = dataset.groups.flatMap { try? $0.get() }.map {
      groups in
      groups.map {
        LCRankedGroup(group: $0, rank: eventDictionary?[$0.id] ?? defaultValue, isFavorite: dataset.favorites.contains($0.id))
      }.sorted {
        $0.rank > $1.rank
      }
    } ?? [LCRankedGroup]()

    return List(result) { group in
      NavigationLink(destination:
        GroupItemView(group: group.group).navigationBarTitle(group.group.name)) {
        GroupRowView(group: group)
      }
    }
  }
}

struct GroupList_Previews: PreviewProvider {
  static var previews: some View {
    let groups = [
      LCGroup(id: "1",
              name: "Web",
              url: URL(string: "https://www.google.com/")!,
              description: "Super Web",
              schedule: "Every 6th Friday",
              icon: .image("fas.coffee"))
    ]
    let data = MockDatastore(groups: groups, events: [LCEvent]())
    return GroupList().environmentObject(Dataset(store: data))
  }
}
