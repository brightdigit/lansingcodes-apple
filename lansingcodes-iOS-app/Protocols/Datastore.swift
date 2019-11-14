import Firebase

protocol DataModel {
  static var queryName: String { get }
  init(document: QueryDocumentSnapshot) throws
}

protocol Datastore {
  func query<ItemType: DataModel>(_ type: ItemType.Type, _ closure: @escaping (Result<[ItemType], Error>) -> Void)
}

extension Firestore: Datastore {
  func query<ItemType: DataModel>(_ type: ItemType.Type, _ closure: @escaping (Result<[ItemType], Error>) -> Void) {
    let name = type.queryName
    collection(name).getDocuments { snapshot, error in
      let result = Result(snapshot, withError: error, defaultError: NoDataError())
      let groups = result.flatMap { snapshot in
        Result {
          try snapshot.documents.map {
            try ItemType(document: $0)
          }
        }
      }
      closure(groups)
    }

    collection(name).addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
      let result = Result(snapshot, withError: error, defaultError: NoDataError())
      let groups = result.flatMap { snapshot in
        Result {
          try snapshot.documents.map {
            try ItemType(document: $0)
          }
        }
      }
      closure(groups)
    }
  }
}
