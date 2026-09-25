//
//  BookTests.swift
//  BookavelleTests
//
//  Created by Rodrigo Cerqueira Reis on 25/09/26.
//

@testable import Bookavelle
import Foundation
import Testing

struct BookTests {
    @Test
    func equality_whenBooksHaveSameValues_returnsTrue() {
        let firstBook = Book(
            id: "OL45804W",
            title: "Fantastic Mr Fox",
            authors: ["Roald Dahl"],
            firstPublishYear: 1970,
            coverURL: nil
        )

        let secondBook = Book(
            id: "OL45804W",
            title: "Fantastic Mr Fox",
            authors: ["Roald Dahl"],
            firstPublishYear: 1970,
            coverURL: nil
        )

        #expect(firstBook == secondBook)
    }

    @Test
    func equality_whenMetadataDiffers_returnsFalse() {
        let originalBook = Book(
            id: "OL45804W",
            title: "Fantastic Mr Fox",
            authors: ["Roald Dahl"],
            firstPublishYear: 1970,
            coverURL: nil
        )

        let updatedBook = Book(
            id: "OL45804W",
            title: "Fantastic Mr Fox",
            authors: ["Roald Dahl"],
            firstPublishYear: 1971,
            coverURL: nil
        )

        #expect(originalBook.id == updatedBook.id)
        #expect(originalBook != updatedBook)
    }

    @Test
    func initialization_whenOptionalMetadataIsMissing_preservesNilValues() {
        let book = Book(
            id: "OL45804W",
            title: "Fantastic Mr Fox",
            authors: ["Roald Dahl"],
            firstPublishYear: nil,
            coverURL: nil
        )

        #expect(book.firstPublishYear == nil)
        #expect(book.coverURL == nil)
    }
}
