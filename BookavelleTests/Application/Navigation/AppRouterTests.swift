//
//  AppRouterTests.swift
//  AppRouterTests
//
//  Created by Rodrigo Cerqueira Reis on 24/09/26.
//

@testable import Bookavelle
import Foundation
import Testing

@MainActor
struct AppRouterTests {
    @Test
    func navigate_whenRouteIsProvided_appendsRouteToPath() {
        let sut = AppRouter()
        let route = AppRouter.Route.bookDetails(id: "book-id")

        sut.navigate(to: route)

        #expect(sut.path == [route])
    }

    @Test
    func goBack_whenPathContainsRoute_removesLastRoute() {
        let sut = AppRouter()
        let firstRoute = AppRouter.Route.bookDetails(id: "first-book")
        let secondRoute = AppRouter.Route.bookDetails(id: "second-book")

        sut.navigate(to: firstRoute)
        sut.navigate(to: secondRoute)

        sut.goBack()

        #expect(sut.path == [firstRoute])
    }

    @Test
    func goBack_whenPathIsEmpty_keepsPathEmpty() {
        let sut = AppRouter()

        sut.goBack()

        #expect(sut.path.isEmpty)
    }

    @Test
    func popToRoot_whenPathContainsRoutes_removesAllRoutes() {
        let sut = AppRouter()

        sut.navigate(to: .bookDetails(id: "first-book"))
        sut.navigate(to: .bookDetails(id: "second-book"))

        sut.popToRoot()

        #expect(sut.path.isEmpty)
    }
}
