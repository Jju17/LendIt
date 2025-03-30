//
//  Item.swift
//  LendIt
//
//  Created by Julien Rahier on 3/20/25.
//

import Foundation

struct Item: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var category: String = "none"
    var condition: String = "none"
}
