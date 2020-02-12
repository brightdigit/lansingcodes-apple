import UIKit

class Dataset: ObservableObject {
  let favoritesStore: FavoritesStore = UDFavoritesStore()
  let geocoder: CachedGeocoder = UDCachedGeocoder()
  let queue: DispatchQueue? = nil
  let defaults: UserDefaults = UserDefaults.standard

  @Published var data: LCDataObject
  @Published var groups: Result<[LCUserGroup], Error>? = nil
  @Published var events: Result<[LCGeocodedEvent], Error>? = nil
  @Published var sponsors: Result<[LCSponsor], Error>? = nil

  init(data: LCDataObject) {
    self.data = data

    // eventDictionary?[$0.id] ?? defaultValue
    let eventsPublisher = self.data.$events.compactMap { $0 }
    let groupsPublisher = self.data.$groups.compactMap { $0 }

    let gePublisher = groupsPublisher.combineLatest(eventsPublisher) { (groupsResult, eventsResult) -> Result<([LCGroup], [LCEvent]), Error> in
      groupsResult.flatMap { (groups) -> Result<([LCGroup], [LCEvent]), Error> in
        eventsResult.map {
          (groups, $0)
        }
      }
    }

    self.data.$groups.combineLatest(defaults.publisher(for: \.favorites))
  }
}
