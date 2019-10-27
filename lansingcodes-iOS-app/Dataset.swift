//
//  DataSet.swift
//  lansingcodes-iOS-app
//
//  Created by Leo Dion on 10/15/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Combine
import Firebase

struct NoDataError : Error {
  
}

struct MissingDocumentFieldError : Error {
  let fieldName : String
}

extension Result {
  init(_ data: Success?, withError error: Failure?, defaultError: Failure) {
    if let data = data {
      self = .success(data)
    } else {
      self = .failure(error ?? defaultError)
    }
  }
  
  var error : Failure? {
    if case let .failure(error) = self {
      return error
    } else {
      return nil
    }
  }
}
struct LCGroup : Identifiable {
  let id: String
  let name : String
  /*
   "name": Web, "schedule": 2nd Wednesday, "description": Share your latest project, talk about tools you're using, network, trade advice, or just chat about the web., "url": https://www.meetup.com/lansingweb/, "slug": lansingweb, "iconName": html5, "iconSet": fab
   */
  init (document: QueryDocumentSnapshot) throws {
    self.id = document.documentID
    guard let name = document.data()["name"] as? String else {
      throw MissingDocumentFieldError(fieldName: "name")
    }
    self.name = name
  }
}
class Dataset : ObservableObject {
  let db : Firestore
  @Published var groups : Result<[LCGroup], Error>?
  
  init (db: Firestore) {
    self.db = db
    
    db.collection("groups").getDocuments { (snapshot, error) in
      let result = Result(snapshot, withError: error, defaultError: NoDataError())
      let groups = result.flatMap { (snapshot) in
        return Result {
          try snapshot.documents.map{
            try LCGroup(document: $0)
          }
        }
      }
      DispatchQueue.main.async {
        debugPrint(groups)
        self.groups = groups
      }
    }
    db.collection("groups").addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
      let result = Result(snapshot, withError: error, defaultError: NoDataError())
      let groups = result.flatMap { (snapshot) in
        return Result {
          try snapshot.documents.map{
            try LCGroup(document: $0)
          }
        }
      }
      DispatchQueue.main.async {
        debugPrint(groups)
        self.groups = groups
      }
    }
  }
}
