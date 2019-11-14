import Foundation

struct MockDatastore: Datastore {
  let groups: [LCGroup]
  func group(_ closure: @escaping (Result<[LCGroup], Error>) -> Void) {
    closure(.success(groups))
  }
}
