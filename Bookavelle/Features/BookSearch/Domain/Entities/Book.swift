//
//  Book.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 25/09/26.
//

import Foundation

nonisolated struct Book: Identifiable, Equatable, Sendable {
    let id: String
    let title: String
    let authors: [String]
    let firstPublishYear: Int?
    let coverURL: URL?
}
