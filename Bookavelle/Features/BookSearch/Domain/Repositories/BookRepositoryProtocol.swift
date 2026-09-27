//
//  BookRepositoryProtocol.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 27/09/26.
//

import Foundation

nonisolated protocol BookRepositoryProtocol: Sendable {
    func searchBooks(
        matching query: String,
        page: Int,
        pageSize: Int
    ) async throws -> [Book]
}
