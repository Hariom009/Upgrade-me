//
//  Subtask.swift
//  Upgrade me
//
//  Created by Hari's Mac on 25.04.2025.
//

import Foundation
class Subtask{
    var id : UUID
    var name : String
    var isCompleted : Bool
    
    init(id: UUID = UUID(), name: String, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
    }
}
