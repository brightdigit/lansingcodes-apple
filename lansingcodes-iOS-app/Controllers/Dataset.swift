import Combine
import CoreLocation
import Firebase

class Dataset: ObservableObject {
  let store: Datastore

  let queue: DispatchQueue?
  @Published var favorites = [LCGroup.ID]()
  // let geocoder = CLGeocoder()

  @Published var groups: Result<[LCGroup], Error>?
  @Published var events: Result<[LCEvent], Error>?
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

  init(store: Datastore, queue: DispatchQueue? = nil) {
    self.store = store
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
