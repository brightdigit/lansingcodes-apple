import Combine
import UIKit
import UserNotifications

class Dataset: ObservableObject {
  let favoritesStore: FavoritesStore = UDFavoritesStore()
  let geocoder: CachedGeocoder = UDCachedGeocoder()
  let queue: DispatchQueue? = nil
  let defaults: UserDefaults = UserDefaults.standard
  let center = UNUserNotificationCenter.current()

  var userGroupsCancellable: AnyCancellable!
  var geoEventsCancellable: AnyCancellable!
  var sponsorsCancellable: AnyCancellable!
  var geocoderCancellable: AnyCancellable!

  @Published var data: LCDataObject
  @Published var groups: Result<[LCUserGroup], Error>?
  @Published var events: Result<[LCGeocodedEvent], Error>?
  @Published var sponsors: Result<[LCSponsor], Error>?
  @Published var unAuthorization: Result<Bool, Error>?

  init(data: LCDataObject) {
    self.data = data

    // eventDictionary?[$0.id] ?? defaultValue
    let eventsPublisher = self.data.$events.compactMap { $0 }
    let groupsPublisher = self.data.$groups.compactMap { $0 }

    geocoderCancellable = eventsPublisher.compactMap {
      try? $0.get().compactMap { $0.location?.address }
    }.sink(receiveValue: geocoder.queue(addressStrings:))
    sponsorsCancellable = self.data.$sponsors.receive(on: DispatchQueue.main).assign(to: \.sponsors, on: self)

    let groupRanksPublisher = eventsPublisher.map { result in
      result.map {
        events in

        [String: [LCEvent]](grouping: events, by: { $0.group }).mapValues {
          events in
          min(events.map { $0.date }.max()?.timeIntervalSinceNow ?? -Double.greatestFiniteMagnitude, 0)
        }
      }
    }

    let favoritesPublisher = defaults.publisher(for: \.favorites).replaceNil(with: [LCGroup.ID]())

    eventsPublisher.compactMap {
      result -> [LCEvent]? in
      try? result.get()
    }.combineLatest(favoritesPublisher) { events, favorites in
      events.filter { favorites.contains($0.group) }
    }.map {
      $0.map {
        event -> UNNotificationRequest in
        let content = UNMutableNotificationContent()
        content.title = event.name
        content.body = event.description
        content.sound = .default
        return UNNotificationRequest(identifier: event.id, content: content, trigger: nil)
      }
    }
//    .flatMap { requests in
//
//      let futures = requests.map {
//        request in
//        Future { completion in
//          self.center.add(request) {
//            completion(Result(Void, withError: $0, defaultError: NoDataError()))
//          }
//        }
//      }
//      return futures.reduce(Just(Result<Void, Error>.success {})) { result, future in
//        result.append(future)
//      }
//    }
    userGroupsCancellable = groupsPublisher.combineLatest(groupRanksPublisher, favoritesPublisher) { groupsResult, ranksResult, favoritesResult in
      let ranks = try? ranksResult.get()
      let defaultValue = ranks == nil ? 0 : -Double.greatestFiniteMagnitude
      return groupsResult.map {
        $0.map {
          LCUserGroup(group: $0, rank: ranks?[$0.id] ?? defaultValue, isFavorite: favoritesResult.contains($0.id))
        }
      }
    }.receive(on: DispatchQueue.main).assign(to: \.groups, on: self)

    geoEventsCancellable = eventsPublisher.combineLatest(defaults.publisher(for: \.coordinates)) { eventsResult, coordinates in
      let lookup = coordinates.flatMap {
        $0 as? [String: Coordinate]
      }
      return eventsResult.map {
        $0.map {
          LCGeocodedEvent(event: $0, coordinate: $0.location.flatMap { lookup?[$0.address] })
        }
      }
    }.receive(on: DispatchQueue.main).assign(to: \.events, on: self)
  }

  func requestAuthorization() {
    center.requestAuthorization(options: [.alert, .badge, .announcement, .sound]) {
      result, error in
      DispatchQueue.main.async {
        self.unAuthorization = Result(result, withError: error, defaultError: NoDataError())
      }
    }
  }
}
