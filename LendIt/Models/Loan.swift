//
//  Loan.swift
//  LendIt
//
//  Created by Julien Rahier on 3/20/25.
//

import Foundation

enum LoanStatus {
    case none
    case inProgress
    case ended
    case late
}

struct Loan: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var borrowerName: String
    var itemId: UUID?
    var borrowerId: UUID?
    var startDate: Date
    var endDate: Date
    var reviewRating: Int?
    var comment: String?
}

extension Loan {
    var status: LoanStatus {
        if self.startDate > Date() && self.endDate < Date() {
            return .inProgress
        } else if self.endDate > Date() {
            return .late
        } else {
            return .none
        }
    }
}
