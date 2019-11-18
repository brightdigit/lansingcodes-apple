import SwiftUI

struct SponsorList: View {
  @EnvironmentObject var dataset: Dataset

  var body: some View {
    ZStack {
      list
      error
      busy
    }
  }

  var list: some View {
    let sponsors = self.dataset.sponsors.flatMap { try? $0.get() } ?? [LCSponsor]()
    return List(sponsors) { sponsor in
      SponsorRowView(sponsor: sponsor).onTapGesture {
        UIApplication.shared.open(sponsor.url)
      }
    }
  }

  var busy: some View {
    Group {
      if self.dataset.sponsors == nil {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
      }
    }
  }

  var error: some View {
    Text(self.dataset.sponsors?.error?.localizedDescription ?? "")
  }
}

struct SponsorList_Previews: PreviewProvider {
  static var previews: some View {
    SponsorList()
  }
}
