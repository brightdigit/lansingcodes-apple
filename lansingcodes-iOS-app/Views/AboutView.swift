import SwiftUI

struct SheetDestination: Identifiable {
  let url: URL
  let name: String

  var id: String {
    return name
  }
}

struct AboutView: View {
  @State var sheetDestination: SheetDestination?

  var lansingCodesView: some View {
    Button(action: {
      self.sheetDestination = SheetDestination(url: URL(string: "https://lansing.codes")!, name: "Lansing Codes WebSite")
    }) {
      VStack {
        Image("Logo").resizable().scaledToFit().frame(minHeight: 40.0, maxHeight: 80.0).padding(-8.0)
        Text("LANSING CODES").font(.title)
        VStack(alignment: .center) {
          Text("Events and resources for Lansing coders")

          Divider()
          Text("For those who code or aspire to, professionally or as a hobby").font(.caption).multilineTextAlignment(.center)
        }
      }
    }
  }

  var slackDiscussionView: some View {
    Button(action: {
      self.sheetDestination = SheetDestination(url: URL(string: "https://slack.lansing.codes")!, name: "Lansing Codes Slack")
    }) {
      VStack {
        Text("Join the Discussion at our Slack").font(.caption).multilineTextAlignment(.center)
        Image("fab.slack").renderingMode(.template).resizable().scaledToFit().frame(minHeight: 30.0, maxHeight: 60.0)
      }
    }
  }

  var developerCreditsView: some View {
    Button(action: {
      self.sheetDestination = SheetDestination(url: URL(string: "https://brightdigit.com")!, name: "BrightDigit")
    }) {
      VStack {
        Text("Developed By").font(.caption).multilineTextAlignment(.center)
        Text("Leo Dion").font(.caption).multilineTextAlignment(.center)
        Image("BrightDigit").renderingMode(.template).resizable().scaledToFit().frame(minHeight: 40.0, maxHeight: 80.0).padding(-8.0)
      }
    }
  }

  var feedbackContributeView: some View {
    Button(action: {
      self.sheetDestination = SheetDestination(url: URL(string: "https://github.com/brightdigit/lansingcodes-apple")!, name: "GitHub Repo")
    }) {
      VStack {
        Text("Submit Your Feedback or Contribute to the App").font(.caption).multilineTextAlignment(.center)
        Image("fab.github").renderingMode(.template).resizable().scaledToFit().frame(minHeight: 30.0, maxHeight: 60.0)
        Text("Version: 1.0-beta.5 (5)").font(.caption).foregroundColor(.gray)
      }
    }
  }

  var body: some View {
    VStack {
      Spacer()
      lansingCodesView
      Spacer(minLength: 4.0)
      slackDiscussionView
      Spacer()
      developerCreditsView
      Spacer()
      feedbackContributeView
      Spacer()
    }.foregroundColor(.primary).actionSheet(item: $sheetDestination) { destination in

      ActionSheet(title: Text(destination.name), message: nil, buttons: [ActionSheet.Button.default(Text("Open Web Browser"), action: {
          UIApplication.shared.open(destination.url, options: [UIApplication.OpenExternalURLOptionsKey: Any](), completionHandler: nil)
        }),
                                                                         .cancel {
          self.sheetDestination = nil
      }])
    }
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
