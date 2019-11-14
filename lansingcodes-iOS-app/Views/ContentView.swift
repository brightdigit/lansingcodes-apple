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
      GroupList()
      error
      busy
    }
  }
  
  
  var busy : some View {
    Group {
      if dataset.groups == nil {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
      }
    }
  }
  
  
  
  var error : some View {
      Text(dataset.groups?.error?.localizedDescription ?? "")
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let groups = [LCGroup(id: "1", name: "Web", url: URL(string: "https://www.google.com/")!, description: "Super Web", icon: .image("fas.coffee"))]
    let data = MockDatastore(groups: groups)
    
    return ContentView().environmentObject(Dataset(db: data))
  }
}
