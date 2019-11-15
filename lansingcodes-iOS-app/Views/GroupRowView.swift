import SwiftUI

struct GroupRowView: View {
  let group: LCGroup
  var body: some View {
    HStack {
      icon.frame(width: 42, height: nil, alignment: .leading)
      Text(group.name)
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
      Image($0).renderingMode(.template)
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

struct GroupRowView_Previews: PreviewProvider {
  static func row(forGroup group: LCGroup) -> some View {
    GroupRowView(group: group).previewLayout(PreviewLayout.fixed(width: 300, height: 50))
  }

  static var previews: some View {
    ForEach([
      LCGroup(id: "1", name: "Web", url: URL(string: "https://www.google.com/")!, description: "Super Web", schedule: "Every 6th Friday", icon: .image("mfizz.script")),

      LCGroup(id: "2", name: "Web", url: URL(string: "https://www.google.com/")!, description: "Super Web", schedule: "Every 6th Friday", icon: .text("mf")),
    ], content: row)
  }
}
