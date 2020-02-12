import Foundation

public struct UDFavoritesStore: FavoritesStore {
  let defaults: UserDefaults

  init(defaults: UserDefaults = UserDefaults.standard) {
    self.defaults = defaults
  }

  public func toggle(_ groupId: LCGroup.ID) {
    guard var favorites = defaults.favorites else {
      defaults.favorites = [groupId]
      return
    }

    let initialCount = favorites.count

    favorites.removeAll(where: { $0 == groupId })

    if favorites.count >= initialCount {
      favorites.append(groupId)
    }

    if favorites.count != initialCount {
      defaults.favorites = favorites
    }
  }
}
