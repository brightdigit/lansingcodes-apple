//
//  GroupList.swift
//  lansingcodes-iOS-app
//
//  Created by Leo Dion on 11/13/19.
//  Copyright © 2019 BrightDigit. All rights reserved.
//

import SwiftUI

struct GroupList: View {
  @EnvironmentObject var dataset : Dataset
    var body: some View {
        
        let result = dataset.groups.flatMap({ try? $0.get() }) ?? [LCGroup]()
        
        return List(result) { (group) in
          GroupRowView(group: group)
        }
    }
}

struct GroupList_Previews: PreviewProvider {
    static var previews: some View {
        GroupList()
    }
}
