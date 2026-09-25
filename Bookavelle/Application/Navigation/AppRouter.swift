//
//  AppRouter.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 24/09/26.
//

import Foundation
import Observation

@Observable
final class AppRouter {
    enum Route: Hashable {
        case bookDetails(id: String)
    }

    var path: [Route] = []

    func navigate(to route: Route) {
        path.append(route)
    }

    func goBack() {
        guard !path.isEmpty else { return }

        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
