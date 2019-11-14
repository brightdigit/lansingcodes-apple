import Combine
import Firebase

class Dataset: ObservableObject {
  let db: Datastore
  let queue: DispatchQueue?
  @Published var groups: Result<[LCGroup], Error>?

  init(db: Datastore, queue: DispatchQueue? = nil) {
    self.db = db
    self.queue = queue
    db.group { groups in
      if let queue = queue {
        queue.async {
          self.groups = groups
        }
      } else {
        self.groups = groups
      }
    }
  }
}
