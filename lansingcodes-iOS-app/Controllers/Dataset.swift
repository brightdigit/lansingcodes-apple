import Combine
import Firebase

class Dataset: ObservableObject {
  let db: Datastore
  let queue: DispatchQueue?
  @Published var groups: Result<[LCGroup], Error>?
  @Published var events: Result<[LCEvent], Error>?
  @Published var sponsors: Result<[LCSponsor], Error>?

  init(db: Datastore, queue: DispatchQueue? = nil) {
    self.db = db
    self.queue = queue
    db.query(LCGroup.self) { groups in
      if let queue = queue {
        queue.async {
          self.groups = groups
        }
      } else {
        self.groups = groups
      }
    }
    db.query(LCEvent.self) { events in
      if let queue = queue {
        queue.async {
          self.events = events
        }
      } else {
        self.events = events
      }
    }
    db.query(LCSponsor.self) { events in
      if let queue = queue {
        queue.async {
          self.sponsors = events
        }
      } else {
        self.sponsors = events
      }
    }
  }
}
