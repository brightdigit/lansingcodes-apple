//
//  GroupRowView.swift
//  lansingcodes-iOS-app
//
//  Created by Leo Dion on 11/12/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

struct GroupRowView: View {
  let group : LCGroup
  var body: some View {
    HStack{
      icon
      Text(group.name)
    }
  }
  
  var icon : some View {
    
    return group.icon.map { (icon) -> Image? in
      guard icon.set != "mfizz" else {
        return nil
      }
      return Image(icon.fullName)
    }
  }
}

struct GroupRowView_Previews: PreviewProvider {
  static var previews: some View {
    GroupRowView(group: LCGroup(id: "1", name: "Web", url: URL(string: "https://www.google.com/")!, description: "Super Web", icon: LCIcon(set: "mfizz", name: "coffee")))
  }
}
