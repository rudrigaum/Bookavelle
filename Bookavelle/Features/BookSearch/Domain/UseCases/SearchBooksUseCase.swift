//
//  SearchBooksUseCase.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 27/09/26.
//

import Foundation

nonisolated struct SearchBooksUseCase: Sendable {
    enum ValidationError: Error, Equatable, Sendable {
        case emptyQuery
        case invalidPage
        case invalidPageSize
    }

    private let repository: any BookRepositoryProtocol

    init(repository: any BookRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        query: String,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> [Book] {
        let normalizedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !normalizedQuery.isEmpty else {
            throw ValidationError.emptyQuery
        }

        guard page > 0 else {
            throw ValidationError.invalidPage
        }

        guard pageSize > 0 else {
            throw ValidationError.invalidPageSize
        }

        return try await repository.searchBooks(
            matching: normalizedQuery,
            page: page,
            pageSize: pageSize
        )
    }
}
