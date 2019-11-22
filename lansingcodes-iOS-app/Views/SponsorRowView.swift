import Combine
import SwiftUI
import UIKit
class URLImage: ObservableObject {
  let url: URL
  let defaultImage: Image
  let publisher: AnyPublisher<Image, Never>
  var cancellable: AnyCancellable!
  @Published var image: Image

  init(url: URL, defaultImage: Image) {
    self.url = url
    self.defaultImage = defaultImage
    image = defaultImage
    publisher = URLSession.shared.dataTaskPublisher(for: url).map(\.data).map { UIImage(data: $0) }.replaceError(with: nil).map {
      $0.map { Image(uiImage: $0) } ?? defaultImage
    }.eraseToAnyPublisher()
    cancellable = publisher.receive(on: DispatchQueue.main).breakpoint().assign(to: \.image, on: self)
  }
}

struct SponsorRowView: View {
  let sponsor: LCSponsor
  @ObservedObject var logoLoader: URLImage

  init(sponsor: LCSponsor) {
    self.sponsor = sponsor
    logoLoader = URLImage(url: self.sponsor.logoUrl, defaultImage: Image("fas.hand-holding-heart"))
  }

  var body: some View {
    VStack(alignment: .leading) {
      logoLoader.image.resizable().scaledToFit().frame(height: 50.0, alignment: .leading)
      Text(sponsor.name).font(.title)
      Text(sponsor.description)
      Spacer()
      Text(sponsor.url.absoluteString).font(.caption)
    }
  }
}

struct SponsorRowView_Previews: PreviewProvider {
  static var previews: some View {
    let sponsor = LCSponsor(
      id: "a2-hosting", name: "A2 Hosting",
      description: "Whether you have a low traffic blog or a popular business site, A2 Hosting has the fast, reliable web hosting for your needs.",
      logoUrl: URL(string: "https://i.imgur.com/pI2XjZb.png")!,
      url: URL(string: "https://www.a2hosting.com")!
    )
    return SponsorRowView(sponsor: sponsor).previewLayout(PreviewLayout.fixed(width: 300, height: 200))
  }
}
