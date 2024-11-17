//
//  Item.swift
//  lets-budget-it-testing-branch
//
//  Created by user267420 on 11/17/24.
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
