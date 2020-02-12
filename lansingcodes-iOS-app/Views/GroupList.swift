import SwiftUI

struct GroupList: View {
  @EnvironmentObject var dataset: Dataset
  var body: some View {
    let result = dataset.groups.flatMap {
      try? $0.get()
    }.map {
      $0.sorted(by: { $0.rank > $1.rank })
    } ?? [LCUserGroup]()

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
    return GroupList().environmentObject(LCDataObject(store: data))
  }
}
