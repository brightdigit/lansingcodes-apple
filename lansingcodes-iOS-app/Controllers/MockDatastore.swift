import Foundation

struct MockDatastore: Datastore {
  func query<ItemType>(_ type: ItemType.Type, _ closure: @escaping (Result<[ItemType], Error>) -> Void) where ItemType: DataModel {
    if type == LCGroup.self {
      // swiftlint:disable:next force_cast
      closure(.success(groups as! [ItemType]))
    } else if type == LCEvent.self {
      // swiftlint:disable:next force_cast
      closure(.success(events as! [ItemType]))
    }
  }

  let groups: [LCGroup]
  let events: [LCEvent]
}
