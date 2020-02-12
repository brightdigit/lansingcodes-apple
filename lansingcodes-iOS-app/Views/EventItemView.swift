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
  let event: LCGeocodedEvent
  let group: LCUserGroup?
  static let taskDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM d, h:mm a"
    return formatter
  }()

  static let titleDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter
  }()

  var iconImage: some View {
    return self.group?.group.icon.flatMap { icon in
      guard case let .image(name) = icon else {
        return nil
      }
      return name
    }.map {
      Image($0).renderingMode(.template).resizable().scaledToFit()
    }
  }

  var iconText: some View {
    return self.group?.group.icon.flatMap { (icon) -> String? in
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
        Text(group.group.name)
          .font(.caption)
      }.padding(.bottom, -8.0)
    }
  }

  var title: String {
    if let group = self.group {
      return "\(group.group.name) - \(Self.titleDateFormat.string(from: event.event.date))"
    } else {
      return event.event.name
    }
  }

  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading) {
        groupView.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 8.0, idealHeight: nil, maxHeight: 12.0, alignment: .leading)
        Text(event.event.name).font(.title)
        Text("\(self.event.event.date, formatter: Self.taskDateFormat)").font(.caption)
        Text(event.event.description)
        link
      }.padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
      Spacer()
      // MapView(landmarks: [LandmarkAnnotation]())
    }.navigationBarTitle(title)
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
      UIApplication.shared.open(self.event.event.url)
    }, label: {
      HStack {
        image(basedOnURL: event.event.url)
        Text("Go To Event Page")
      }
    })
  }
}

struct EventItemView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EventItemView(event: LCGeocodedEvent(
        event: LCEvent(
          id: UUID().uuidString,
          location: LCLocation(venue: "New Place", address: "", placemark: nil),
          description: "Talk about stuff", name: "Lean Coffee Code",
          date: Date(),
          url: URL(string: "https://google.com")!,
          group: "meetups"
        ), coordinate: nil
      ), group: nil)
    }
  }
}
