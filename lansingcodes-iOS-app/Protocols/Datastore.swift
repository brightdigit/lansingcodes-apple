import Firebase

protocol Datastore {
  func group(_ closure: @escaping (Result<[LCGroup], Error>) -> Void)
}


extension Firestore : Datastore {
  func group(_ closure: @escaping (Result<[LCGroup], Error>) -> Void) {
        self.collection("groups").getDocuments { (snapshot, error) in
          let result = Result(snapshot, withError: error, defaultError: NoDataError())
          let groups = result.flatMap { (snapshot) in
            return Result {
              try snapshot.documents.map{
                try LCGroup(document: $0)
              }
            }
          }
          closure(groups)
        }
    
        self.collection("groups").addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
          let result = Result(snapshot, withError: error, defaultError: NoDataError())
          let groups = result.flatMap { (snapshot) in
            return Result {
              try snapshot.documents.map{
                try LCGroup(document: $0)
              }
            }
          }
          closure(groups)
        }
  }
  
  
}
