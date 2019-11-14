import SwiftUI

struct GroupItemView: View {
  let group: LCGroup

  var body: some View {
    VStack(alignment: HorizontalAlignment.leading) {
      icon.scaledToFit().frame(minWidth: 0, maxWidth: 100, alignment: .topLeading)
      link
      HTMLView(text: group.attributedDescription).background(Color.yellow).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      Spacer()
      EventList(groupId: group.id)
    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading).padding(20.0)
  }

  var link: some View {
    Button(action: {
      UIApplication.shared.open(self.group.url)
    }) {
      HStack {
        image(basedOnURL: group.url)
        Text("Meets every \(group.schedule)")
      }
    }
  }

  func image(basedOnURL url: URL) -> some View {
    if url.host?.contains("meetup") == true {
      return Image("fab.meetup")
    } else {
      return Image("fas.globe")
    }
  }

  var icon: some View {
    ZStack {
      iconImage
      iconText
    }
  }

  var iconImage: some View {
    return self.group.icon.flatMap { icon in
      guard case let .image(name) = icon else {
        return nil
      }
      return name
    }.map {
      Image($0).resizable()
    }
  }

  var iconText: some View {
    return self.group.icon.flatMap { (icon) -> String? in
      guard case let .text(string) = icon else {
        return nil
      }
      return string
    }.map {
      Text($0).font(.system(size: 24, weight: .black))
    }
  }
}

struct GroupItemView_Previews: PreviewProvider {
  static var previews: some View {
    let group = LCGroup(id: "test", name: "Test", url: URL(string: "https://google.com")!, description: """
    It's easy to spin your wheels pounding at the keyboard, but a focus on <em>process</em> will make you orders of magnitude more effective.
    """, schedule: "Every 6th Friday", icon: .image("fab.js-square"))
    return NavigationView { GroupItemView(group: group).navigationBarTitle(group.name)
    }
  }
}
