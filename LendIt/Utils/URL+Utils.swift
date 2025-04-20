//
//  URL+Utils.swift
//  colockitchenrace
//
//  Created by Julien Rahier on 02/06/2024.
//

import Foundation

extension URL {
    static let borrowers = Self.documentsDirectory.appending(component: "borrowers.json")
    static let items = Self.documentsDirectory.appending(component: "items.json")
    static let loans = Self.documentsDirectory.appending(component: "loans.json")
}
