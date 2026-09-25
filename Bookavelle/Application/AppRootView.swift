//
//  AppRootView.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 24/09/26.
//

import Foundation
import SwiftUI

struct AppRootView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            ContentView()
        }
    }
}

#Preview {
    AppRootView()
        .environment(AppRouter())
}
