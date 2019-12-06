import SwiftUI

struct AboutView: View {
  var body: some View {
    VStack {
      Spacer()
      VStack {
        Image("Logo").resizable().scaledToFit().frame(minHeight: 40.0, maxHeight: 80.0)
        Text("LANSING CODES").font(.title)
        VStack(alignment: .center) {
          Text("Events and resources for Lansing coders")

          Divider()
          Text("For those who code or aspire to, professionally or as a hobby").font(.caption).multilineTextAlignment(.center)
        }
      }
      Spacer(minLength: 4)
      VStack {
        Text("Join the Discussion at our Slack").font(.caption).multilineTextAlignment(.center)
        Image("fab.slack").renderingMode(.template).resizable().scaledToFit().frame(minHeight: 30.0, maxHeight: 60.0)
      }
      Spacer()
      VStack {
        Text("Developed By")
        Text("Leo Dion")
        Image("BrightDigit").renderingMode(.template).resizable().scaledToFit().frame(minHeight: 40.0, maxHeight: 80.0)
      }
      Spacer()
      VStack {
        Text("Submit Your Feedback or Contribute to the App")
        Image("fab.github").renderingMode(.template).resizable().scaledToFit().frame(minHeight: 30.0, maxHeight: 60.0)
        Text("Version: 1.0-beta.5 (5)").font(.caption).foregroundColor(.gray)
      }
      Spacer()
    }.padding(20.0)
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    TabView {
      NavigationView {
        ZStack {
          AboutView()
        }.navigationBarTitle("About")
      }.navigationViewStyle(StackNavigationViewStyle()).tabItem {
        Image("far.thumbs-up").renderingMode(.template)
        Text("About")
      }.tag(3)
    }
  }
}
