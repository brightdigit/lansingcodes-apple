import Foundation

struct LCUserGroup: Identifiable {
  let group: LCGroup
  let rank: Double
  let isFavorite: Bool

  var id: String {
    return group.id
  }
}
