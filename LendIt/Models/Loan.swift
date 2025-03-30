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
    var id: UUID // identifiant unique du prêt
    var name: String
    var itemId: UUID? // lien vers l’objet prêté
    var borrowerId: UUID? // lien vers l’emprunteur
    var startDate: Date // date de début du prêt
    var endDate: Date // date de fin prévue
    var reviewRating: Int? // note laissée après le prêt, nullable si pas encore évalué
    var comment: String? // commentaire optionnel
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
