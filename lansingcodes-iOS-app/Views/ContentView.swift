import SwiftUI

struct ContentView: View {
  @EnvironmentObject var dataset: Dataset
  var body: some View {
    TabView {
      NavigationView {
        ZStack {
          GroupList()
          error
          busy
        }.navigationBarTitle("Groups")
      }.tabItem {
        Image("fas.users").renderingMode(.template)
        Text("Groups")
      }.tag(0)
      NavigationView {
        ZStack {
          EventList(groupId: nil)
          error
          busy
        }.navigationBarTitle("Events")
      }.tabItem {
        Image("far.calendar-alt").renderingMode(.template)
        Text("Events")
      }.tag(1)
      NavigationView {
        ZStack {
          SponsorList()
          error
          busy
        }.navigationBarTitle("Sponsors")
      }.tabItem {
        Image("fas.hand-holding-heart").renderingMode(.template)
        Text("Sponsors")
      }.tag(2)
      NavigationView {
        ZStack {
          AboutView()
          error
          busy
        }.navigationBarTitle("About")
      }.tabItem {
        Image("far.thumbs-up").renderingMode(.template)
        Text("About")
      }.tag(3)
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

    return ContentView().environmentObject(Dataset(db: data)).environment(\.colorScheme, .dark)
  }
}
