//
//  MockDatastore.swift
//  lansingcodes-iOS-app
//
//  Created by Leo Dion on 11/13/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import Foundation


struct MockDatastore : Datastore {
  let groups : [LCGroup]
  func group(_ closure: @escaping (Result<[LCGroup], Error>) -> Void) {
    closure(.success(self.groups))
  }
  
  
}
