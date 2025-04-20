//
//  Borrower.swift
//  LendIt
//
//  Created by Julien Rahier on 4/20/25.
//

import Foundation

struct Borrower: Codable, Equatable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var phone: String?
    var email: String?
}

