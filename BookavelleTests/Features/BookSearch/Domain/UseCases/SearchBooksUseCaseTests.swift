//
//  SearchBooksUseCaseTests.swift
//  BookavelleTests
//
//  Created by Rodrigo Cerqueira Reis on 27/09/26.
//

@testable import Bookavelle
import Foundation
import Testing

nonisolated struct SearchBooksUseCaseTests {
    @Test
    func execute_whenQueryIsValid_returnsBooks() async throws {
        let expectedBook = Book(
            id: "OL27448W",
            title: "Dune",
            authors: ["Frank Herbert"],
            firstPublishYear: 1965,
            coverURL: nil
        )

        let repository = BookRepositorySpy(books: [expectedBook])
        let sut = SearchBooksUseCase(repository: repository)

        let result = try await sut.execute(query: "Dune")
        let calls = await repository.calls

        #expect(result == [expectedBook])
        #expect(
            calls == [
                SearchCall(
                    query: "Dune",
                    page: 1,
                    pageSize: 20
                ),
            ]
        )
    }

    @Test
    func execute_whenQueryContainsWhitespace_normalizesQuery() async throws {
        let repository = BookRepositorySpy()
        let sut = SearchBooksUseCase(repository: repository)

        _ = try await sut.execute(
            query: "  Harry Potter  ",
            page: 2,
            pageSize: 10
        )

        let calls = await repository.calls

        #expect(
            calls == [
                SearchCall(
                    query: "Harry Potter",
                    page: 2,
                    pageSize: 10
                ),
            ]
        )
    }

    @Test
    func execute_whenQueryIsEmpty_throwsValidationError() async {
        let repository = BookRepositorySpy()
        let sut = SearchBooksUseCase(repository: repository)

        await #expect(
            throws: SearchBooksUseCase.ValidationError.emptyQuery
        ) {
            try await sut.execute(query: "   ")
        }

        let calls = await repository.calls
        #expect(calls.isEmpty)
    }

    @Test
    func execute_whenPageIsInvalid_throwsValidationError() async {
        let repository = BookRepositorySpy()
        let sut = SearchBooksUseCase(repository: repository)

        await #expect(
            throws: SearchBooksUseCase.ValidationError.invalidPage
        ) {
            try await sut.execute(query: "Dune", page: 0)
        }

        let calls = await repository.calls
        #expect(calls.isEmpty)
    }

    @Test
    func execute_whenPageSizeIsInvalid_throwsValidationError() async {
        let repository = BookRepositorySpy()
        let sut = SearchBooksUseCase(repository: repository)

        await #expect(
            throws: SearchBooksUseCase.ValidationError.invalidPageSize
        ) {
            try await sut.execute(
                query: "Dune",
                pageSize: -1
            )
        }

        let calls = await repository.calls
        #expect(calls.isEmpty)
    }

    @Test
    func execute_whenRepositoryFails_propagatesError() async {
        let repository = BookRepositorySpy(
            error: .unavailable
        )
        let sut = SearchBooksUseCase(repository: repository)

        await #expect(throws: RepositorySpyError.unavailable) {
            try await sut.execute(query: "Dune")
        }
    }
}

// MARK: - Test Doubles

nonisolated struct SearchCall: Equatable, Sendable {
    let query: String
    let page: Int
    let pageSize: Int
}

nonisolated enum RepositorySpyError: Error, Equatable {
    case unavailable
}

actor BookRepositorySpy: BookRepositoryProtocol {
    private(set) var calls: [SearchCall] = []

    private let books: [Book]
    private let error: RepositorySpyError?

    init(
        books: [Book] = [],
        error: RepositorySpyError? = nil
    ) {
        self.books = books
        self.error = error
    }

    func searchBooks(
        matching query: String,
        page: Int,
        pageSize: Int
    ) async throws -> [Book] {
        calls.append(
            SearchCall(
                query: query,
                page: page,
                pageSize: pageSize
            )
        )

        if let error {
            throw error
        }

        return books
    }
}
