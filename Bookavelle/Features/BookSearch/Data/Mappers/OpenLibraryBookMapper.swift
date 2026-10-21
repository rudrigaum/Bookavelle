//
//  OpenLibraryBookMapper.swift
//  Bookavelle
//
//  Created by Rodrigo Cerqueira Reis on 20/10/26.
//

import Foundation

nonisolated struct OpenLibraryBookMapper: Sendable {
    func map(_ response: OpenLibrarySearchResponseDTO) -> [Book] {
        response.docs.compactMap { map($0) }
    }

    func map(_ work: OpenLibraryWorkDTO) -> Book? {
        guard
            let id = normalizedWorkID(from: work.key),
            let title = work.title?.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            !title.isEmpty
        else {
            return nil
        }

        return Book(
            id: id,
            title: title,
            authors: work.authorNames ?? [],
            firstPublishYear: work.firstPublishYear,
            coverURL: coverURL(for: work.coverID)
        )
    }

    private func normalizedWorkID(from key: String?) -> String? {
        guard let key = key?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ) else {
            return nil
        }

        let id = if key.hasPrefix("/works/") {
            String(key.dropFirst("/works/".count))
        } else {
            key
        }

        guard id.hasPrefix("OL"), id.hasSuffix("W") else {
            return nil
        }

        let numericPart = id.dropFirst(2).dropLast()

        guard
            !numericPart.isEmpty,
            numericPart.allSatisfy({ $0 >= "0" && $0 <= "9" })
        else {
            return nil
        }

        return id
    }

    private func coverURL(for coverID: Int?) -> URL? {
        guard let coverID, coverID > 0 else {
            return nil
        }

        return URL(
            string: "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg?default=false"
        )
    }
}
