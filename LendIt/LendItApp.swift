//
//  LendItApp.swift
//  LendIt
//
//  Created by Julien Rahier on 3/20/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct LendItApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State.tab(MyTabFeature.State())
                ) {
                    AppFeature()
                        ._printChanges()
                }
            )
        }
    }
}
