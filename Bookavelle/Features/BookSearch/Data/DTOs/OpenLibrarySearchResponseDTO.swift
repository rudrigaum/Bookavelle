//
//  OpenLibrarySearchResponseDTO.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 27/09/26.
//

import Foundation

nonisolated struct OpenLibrarySearchResponseDTO: Decodable, Sendable {
    let docs: [OpenLibraryWorkDTO]
}

nonisolated struct OpenLibraryWorkDTO: Decodable, Sendable {
    let key: String?
    let title: String?
    let authorNames: [String]?
    let firstPublishYear: Int?
    let coverID: Int?

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorNames = "author_name"
        case firstPublishYear = "first_publish_year"
        case coverID = "cover_i"
    }
}
