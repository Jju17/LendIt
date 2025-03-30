//
//  NewLoanForm.swift
//  colockitchenrace
//
//  Created by Julien Rahier on 09/10/2023.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct NewLoanFormFeature {
    @ObservableState
    struct State {
        var wipLoan: Loan
        var isNewCohouse: Bool = false
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}

struct NewLoanFormView: View {
    @Bindable var store: StoreOf<NewLoanFormFeature>

    var body: some View {
        Form {
            Section {
                TextField("Loan name", text: $store.wipLoan.name)
            }
        }
    }
}

#Preview {
    NewLoanFormView(
        store: Store(initialState: NewLoanFormFeature.State(wipLoan: Loan(id: UUID(), name: "New loan", startDate: Date(), endDate: Date().addingTimeInterval(86400)))) {
            NewLoanFormFeature()
        })
}
