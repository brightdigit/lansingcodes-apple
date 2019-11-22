import Foundation

struct LCRankedGroup: Identifiable {
  let group: LCGroup
  let rank: Double

  var id: String {
    return group.id
  }
}
