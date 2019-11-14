import SwiftUI

struct GroupList: View {
  @EnvironmentObject var dataset: Dataset
  var body: some View {
    let result = dataset.groups.flatMap { try? $0.get() } ?? [LCGroup]()

    return List(result) { group in
      NavigationLink(destination:
        GroupItemView(group: group).navigationBarTitle(group.name)) {
        GroupRowView(group: group)
      }
    }
  }
}

struct GroupList_Previews: PreviewProvider {
  static var previews: some View {
    GroupList()
  }
}
