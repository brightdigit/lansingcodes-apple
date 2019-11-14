import SwiftUI

struct ContentView: View {
  @EnvironmentObject var dataset: Dataset
  var body: some View {
    NavigationView {
      ZStack {
        GroupList()
        error
        busy
      }.navigationBarTitle("Groups")
    }
  }

  var busy: some View {
    Group {
      if dataset.groups == nil {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
      }
    }
  }

  var error: some View {
    Text(dataset.groups?.error?.localizedDescription ?? "")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let groups = [LCGroup(id: "1", name: "Web", url: URL(string: "https://www.google.com/")!, description: "Super Web", schedule: "Every 6th Friday", icon: .image("fas.coffee"))]
    let data = MockDatastore(groups: groups, events: [LCEvent]())

    return ContentView().environmentObject(Dataset(db: data))
  }
}
