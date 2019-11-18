import SwiftUI

struct SponsorRowView: View {
  let sponsor: LCSponsor?
  var body: some View {
    Text("test")
  }
}

struct SponsorRowView_Previews: PreviewProvider {
  static var previews: some View {
//    let sponsor = LCSponsor(
//      id: "a2-hosting", name: "A2 Hosting",
//      description: "Whether you have a low traffic blog or a popular business site, A2 Hosting has the fast, reliable web hosting for your needs.",
//      logoUrl: URL(string: "https://i.imgur.com/pI2XjZb.png")!,
//      url: URL(string: "https://www.a2hosting.com")!
//    )
    return SponsorRowView(sponsor: nil)
  }
}
