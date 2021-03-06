import MapKit
import SwiftUI

class LandmarkAnnotation: NSObject, MKAnnotation {
  let title: String?
  let subtitle: String?
  let coordinate: CLLocationCoordinate2D
  init(title: String?,
       subtitle: String?,
       coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.subtitle = subtitle
    self.coordinate = coordinate
  }
}

struct MapView: UIViewRepresentable {
  // Model with test data
  let landmarks: [LandmarkAnnotation]

  /**
   - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
   */
  func makeUIView(context _: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }

  func updateUIView(_ view: MKMapView, context _: Context) {
    // If you changing the Map Annotation then you have to remove old Annotations
    // mapView.removeAnnotations(mapView.annotations)
    // passing model array here
    view.addAnnotations(landmarks)
  }
}

struct EventItemView: View {
  let event: LCEvent
  let group: LCGroup?
  static let taskDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM d, h:mm a"
    return formatter
  }()

  var iconImage: some View {
    return self.group?.icon.flatMap { icon in
      guard case let .image(name) = icon else {
        return nil
      }
      return name
    }.map {
      Image($0).renderingMode(.template).resizable().scaledToFit()
    }
  }

  var iconText: some View {
    return self.group?.icon.flatMap { (icon) -> String? in
      guard case let .text(string) = icon else {
        return nil
      }
      return string
    }.map {
      Text($0).font(.system(size: 16.0, weight: .black))
    }
  }

  var icon: some View {
    ZStack {
      iconImage
      iconText
    }
  }

  var groupView: some View {
    self.group.map {
      group in
      HStack {
        icon
        Text(group.name)
          .font(.caption)
      }.padding(.bottom, -8.0)
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading) {
        groupView.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 8.0, idealHeight: nil, maxHeight: 12.0, alignment: .leading)
        Text("\(self.event.date, formatter: Self.taskDateFormat)").font(.caption)
        Text(event.description)
        link
      }.padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
      Spacer()
      // MapView(landmarks: [LandmarkAnnotation]())
    }.navigationBarTitle(event.name)
  }

  func image(basedOnURL url: URL) -> some View {
    if url.host?.contains("meetup") == true {
      return Image("fab.meetup")
    } else {
      return Image("fas.globe")
    }
  }

  var link: some View {
    Button(action: {
      UIApplication.shared.open(self.event.url)
    }, label: {
      HStack {
        image(basedOnURL: event.url)
        Text("Go To Event Page")
      }
    })
  }
}

struct EventItemView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EventItemView(event: LCEvent(
        id: UUID().uuidString,
        location: LCLocation(venue: "New Place", address: "", placemark: nil),
        description: "Talk about stuff", name: "Lean Coffee Code",
        date: Date(),
        url: URL(string: "https://google.com")!,
        group: "meetups"
      ), group: nil)
    }
  }
}
