//
//  Item.swift
//  SwiftDataDemoProject
//
//  Created by 홍세희 on 2023/12/28.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
