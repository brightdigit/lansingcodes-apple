//
//  DataSet.swift
//  lansingcodes-iOS-app
//
//  Created by Leo Dion on 10/15/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Combine
import Firebase

struct TryConvert {
  public static func fromStringOf<T>(_ object: Any, byConverting convert: (String) -> T?) -> T? {
    if let string = object as? String {
      return convert(string)
    }
    return nil
  }
}

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
enum LCIcon {
  case image(String)
  case text(String)
}
//struct ObsoleteLCIcon {
//  let set : String
//  let name : String
//
//  var fullName : String {
//    return [set,name].joined(separator: ".")
//  }
//}
struct LCGroup : Identifiable {
  let id: String
  let name : String
  let url : URL
  let description : String
  let icon : LCIcon?
  /*
   "name": Web, "schedule": 2nd Wednesday, "description": Share your latest project, talk about tools you're using, network, trade advice, or just chat about the web., "url": https://www.meetup.com/lansingweb/, "slug": lansingweb, "iconName": html5, "iconSet": fab
   */
  init (id: String,
name : String,
url : URL,
description : String,
icon : LCIcon? = nil) {
    self.id = id
    self.name = name
    self.url = url
    self.description = description
    self.icon = icon
  }
  init (document: QueryDocumentSnapshot) throws {
    self.id = document.documentID
    guard let name = document.data()["name"] as? String else {
      throw MissingDocumentFieldError(fieldName: "name")
    }
    guard let url = TryConvert.fromStringOf(document.data()["url"], byConverting: { URL(string: $0)})  else {
      throw MissingDocumentFieldError(fieldName: "url")
    }
    guard let description = document.data()["description"] as? String else {
      throw MissingDocumentFieldError(fieldName: "description")
    }
    self.name = name
    self.url = url
    self.description = description
    if let iconSet = document.data()["iconSet"] as? String, let iconName = document.data()["iconName"] as? String {

      self.icon = .image([iconSet,iconName].joined(separator: "."))
    } else if let iconText = document.data()["iconText"] as? String {
      self.icon = .text(iconText)
    } else {
      self.icon = nil
    }
  }
}

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

typealias DatasetCallback = (()->Void)->Void

class Dataset : ObservableObject {
  let db : Datastore
  let queue : DispatchQueue?
  @Published var groups : Result<[LCGroup], Error>?
  
  
  init (db: Datastore, queue: DispatchQueue? = nil) {
    self.db = db
    self.queue = queue
    db.group { (groups) in
      if let queue = queue {
        queue.async {
          self.groups = groups
        }
      } else {
        self.groups = groups
      }
//      callback{
//        self.groups = groups
//      }
//      DispatchQueue.main.async {
//        debugPrint(groups)
//        self.groups = groups
//      }
    }
  

  }
  
//  convenience init(db: Datastore, queue: DispatchQueue? = nil) {
//    let queue = queue ?? DispatchQueue.main
//  
//    
//  }
}
