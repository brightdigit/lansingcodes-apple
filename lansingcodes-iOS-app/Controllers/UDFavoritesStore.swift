import Foundation

public struct UDFavoritesStore: FavoritesStore {
  let defaults: UserDefaults

  init(defaults: UserDefaults = UserDefaults.standard) {
    self.defaults = defaults
  }
}
