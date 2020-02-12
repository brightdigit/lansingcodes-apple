import Combine
import CoreLocation
import Firebase

extension UserDefaults {
  @objc dynamic var favorites: [LCGroup.ID]? {
    get {
      return array(forKey: "favorites") as? [LCGroup.ID]
    }
    set(value) {
      `set`(value, forKey: "favorites")
    }
  }
}

class LCDataObject: ObservableObject {
  let store: Datastore

  // @Published var favorites = [LCGroup.ID]()
  // let geocoder = CLGeocoder()

  @Published var groups: Result<[LCGroup], Error>?
  @Published var events: Result<[LCEvent], Error>?
//    {
//    didSet {
//      guard let addresses = self.events.flatMap({ try? $0.get() }).map({ $0.compactMap { $0.location?.address } }) else {
//        return
//      }
//
//      geocoder.queue(addressStrings: addresses)
//    }
//  }

//    {
//    didSet {
//      if let events = self.events.flatMap({
//        try? $0.get()
//      }) {
  ////        let queuedEvents = self.events.flatMap{
  ////          try? $0.get()
  ////        }.map{
  ////          return $0.compactMap{
  ////            event -> (event: LCEvent, location: LCLocation)? in
  ////            event.location.flatMap{
  ////              location in
  ////              guard location.placemark == nil else {
  ////                return nil
  ////              }
  ////              return (event: event, location: location)
  ////            }
  ////          }
  ////        }
  ////        guard let geocodingEvents = queuedEvents else {
  ////          return
  ////        }
  ////        guard geocodingEvents.count > 0 else {
  ////          return
  ////        }
//        var newEvents = [LCEvent]()
//        var queuedEvents = [(event: LCEvent, location: LCLocation)]()
//        for event in events {
//          guard let location = event.location else {
//            newEvents.append(event)
//            continue
//          }
//          guard event.location?.placemark == nil else {
//            newEvents.append(event)
//            continue
//          }
//          queuedEvents.append((event: event, location: location))
//        }
//        guard queuedEvents.count > 0 else {
//          return
//        }
//        let group = DispatchGroup()
//        group.enter()
//        for (event, location) in queuedEvents {
//          geocoder.geocodeAddressString(location.address) { placemarks, error in
//            let geocodingResult = Result(placemarks?.first, withError: error, defaultError: NoDataError())
//            newEvents.append(LCEvent(event: event, withGeocodingResult: geocodingResult))
//            group.leave()
//          }
//        }
//        group.notify(queue: queue ?? DispatchQueue.global()) {
//          self.events = .success(newEvents)
//        }
//      }
//    }
//  }

  @Published var sponsors: Result<[LCSponsor], Error>?
  let queue: DispatchQueue?

  init(store: Datastore, queue: DispatchQueue? = nil) {
    // let favoritesPublisher = defaults.publisher(for: \.favorites)
    // self.defaults = defaults
    self.store = store
    // self.favoritesStore = favoritesStore ?? UDFavoritesStore(defaults: defaults)
    // self.geocoder = geocoder ?? UDCachedGeocoder(defaults: defaults)
    self.queue = queue
    store.query(LCGroup.self) { groups in
      if let queue = queue {
        queue.async {
          self.groups = groups
        }
      } else {
        self.groups = groups
      }
    }
    store.query(LCEvent.self) { events in
      if let queue = queue {
        queue.async {
          self.events = events
        }
      } else {
        self.events = events
      }
    }
    store.query(LCSponsor.self) { events in
      if let queue = queue {
        queue.async {
          self.sponsors = events
        }
      } else {
        self.sponsors = events
      }
    }
  }
}
