import Combine
import Firebase

class Dataset: ObservableObject {
  let store: Datastore
  let queue: DispatchQueue?
  @Published var groups: Result<[LCGroup], Error>?
  @Published var events: Result<[LCEvent], Error>?
  @Published var sponsors: Result<[LCSponsor], Error>?

  init(store: Datastore, queue: DispatchQueue? = nil) {
    self.store = store
    self.queue = queue
    store.query(LCGroup.self) { groups in
      if let queue = queue {
        queue.async {
          self.groups = groups
        }
      } else {
        self.groups = groups
      }
    }
    store.query(LCEvent.self) { events in
      if let queue = queue {
        queue.async {
          self.events = events
        }
      } else {
        self.events = events
      }
    }
    store.query(LCSponsor.self) { events in
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
