//
//  LoanCellView.swift
//  LendIt
//
//  Created by Julien Rahier on 4/20/25.
//

import SwiftUI

struct LoanCellView: View {
    let loan: Loan

    var body: some View {
        VStack(alignment: .leading) {
            Text("loan.title: \(loan.name)")
            Text("loan.item: \(loan.itemName)")
            Text("loan.borrower: \(loan.borrowerName)")
            Text("loan.startDate: \(loan.startDate.formatted(date: .abbreviated, time: .shortened))")
            Text("loan.endDate: \(loan.endDate.formatted(date: .abbreviated, time: .shortened))")
            if !loan.comment.isEmpty {
                Text("loan.comment: \(loan.comment)")
            }
        }
    }
}
