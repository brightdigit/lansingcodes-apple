//
//  ContentView.swift
//  lansingcodes-iOS-app
//
//  Created by Leo Dion on 10/14/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var dataset : Dataset
  var body: some View {
    ZStack {
      list
      error
      busy
    }
  }
  
  
  var busy : some View {
    Group {
      if dataset.groups == nil {
        Text("Busy")
      }
    }
  }
  
  var list : some View {
    let result = dataset.groups.flatMap({ try? $0.get() }) ?? [LCGroup]()
    
    return List(result) { (group) in
          Text(group.name)
    }
     
  }
  
  var error : some View {
      Text(dataset.groups?.error?.localizedDescription ?? "")
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    
    ContentView()
  }
}
