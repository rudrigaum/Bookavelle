//
//  BookavelleApp.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 22/09/26.
//

import SwiftUI

@main
struct BookavelleApp: App {
    @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(router)
        }
    }
}
