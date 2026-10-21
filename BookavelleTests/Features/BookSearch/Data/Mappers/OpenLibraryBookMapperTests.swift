//
//  OpenLibraryBookMapperTests.swift
//  BookavelleTests
//
//  Created by Rodrigo Cerqueira Reis on 20/10/26.
//

@testable import Bookavelle
import Foundation
import Testing

nonisolated struct OpenLibraryBookMapperTests {
    private let sut = OpenLibraryBookMapper()

    @Test
    func map_whenWorkIsValid_createsBook() throws {
        let work = makeWork(
            key: "/works/OL27448W",
            title: "  Dune  ",
            authorNames: ["Frank Herbert"],
            firstPublishYear: 1965,
            coverID: 123_456
        )

        let book = try #require(sut.map(work))

        let expectedCoverURL = URL(
            string: "https://covers.openlibrary.org/b/id/123456-M.jpg?default=false"
        )

        #expect(book.id == "OL27448W")
        #expect(book.title == "Dune")
        #expect(book.authors == ["Frank Herbert"])
        #expect(book.firstPublishYear == 1965)
        #expect(book.coverURL == expectedCoverURL)
    }

    @Test
    func map_whenWorkIDHasNoPrefix_preservesID() throws {
        let work = makeWork(key: "OL27448W")

        let book = try #require(sut.map(work))

        #expect(book.id == "OL27448W")
    }

    @Test
    func map_whenWorkIDIsInvalid_returnsNil() {
        let invalidKeys: [String?] = [
            nil,
            "",
            "/authors/OL27448W",
            "OLABCW",
            "/works/OL27448W/extra"
        ]

        for key in invalidKeys {
            let work = makeWork(key: key)

            #expect(sut.map(work) == nil)
        }
    }

    @Test
    func map_whenWorkIDContainsNonASCIIDigits_returnsNil() {
        let invalidKeys = [
            "OL١٢٣W",
            "OL１２３W"
        ]

        for key in invalidKeys {
            let work = makeWork(key: key)

            #expect(sut.map(work) == nil)
        }
    }

    @Test
    func map_whenTitleIsMissingOrBlank_returnsNil() {
        let missingTitle = makeWork(title: nil)
        let blankTitle = makeWork(title: "  \n  ")

        #expect(sut.map(missingTitle) == nil)
        #expect(sut.map(blankTitle) == nil)
    }

    @Test
    func map_whenOptionalFieldsAreMissing_usesDefaults() throws {
        let work = makeWork()

        let book = try #require(sut.map(work))

        #expect(book.authors.isEmpty)
        #expect(book.firstPublishYear == nil)
        #expect(book.coverURL == nil)
    }

    @Test
    func map_whenCoverIDIsInvalid_omitsCoverURL() throws {
        let zeroCoverID = makeWork(coverID: 0)
        let negativeCoverID = makeWork(coverID: -1)

        let firstBook = try #require(sut.map(zeroCoverID))
        let secondBook = try #require(sut.map(negativeCoverID))

        #expect(firstBook.coverURL == nil)
        #expect(secondBook.coverURL == nil)
    }

    @Test
    func map_whenResponseContainsInvalidWorks_filtersAndPreservesOrder() {
        let response = OpenLibrarySearchResponseDTO(
            docs: [
                makeWork(key: "OL123W", title: "First"),
                makeWork(key: "invalid", title: "Invalid"),
                makeWork(key: "OL456W", title: "Second"),
                makeWork(key: "OL789W", title: "   ")
            ]
        )

        let books = sut.map(response)

        #expect(books.count == 2)
        #expect(books.map(\.id) == ["OL123W", "OL456W"])
        #expect(books.map(\.title) == ["First", "Second"])
    }

    // MARK: - Test Fixtures

    private func makeWork(
        key: String? = "/works/OL27448W",
        title: String? = "Dune",
        authorNames: [String]? = nil,
        firstPublishYear: Int? = nil,
        coverID: Int? = nil
    ) -> OpenLibraryWorkDTO {
        OpenLibraryWorkDTO(
            key: key,
            title: title,
            authorNames: authorNames,
            firstPublishYear: firstPublishYear,
            coverID: coverID
        )
    }
}
