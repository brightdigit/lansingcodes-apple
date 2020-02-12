import Foundation

public protocol FavoritesStore {
  func toggle(_ groupId: LCGroup.ID)
}
