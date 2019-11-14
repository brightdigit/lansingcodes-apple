import SwiftUI

struct GroupItemView: View {
  let group: LCGroup

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct GroupItemView_Previews: PreviewProvider {
  static var previews: some View {
    let group = LCGroup(id: "test", name: "Test", url: URL(string: "https://google.com")!, description: "Google")
    return GroupItemView(group: group)
  }
}
