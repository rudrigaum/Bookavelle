//
//  OpenLibrarySearchResponseDTOTests.swift
//  BookavelleTests
//
//  Created by Rodrigo Cerqueira Reis on 27/09/26.
//

@testable import Bookavelle
import Foundation
import Testing

nonisolated struct OpenLibrarySearchResponseDTOTests {
    @Test
    func decoding_whenAllFieldsExist_decodesSuccessfully() throws {
        let json = """
        {
            "docs": [
                {
                    "key": "/works/OL27448W",
                    "title": "Dune",
                    "author_name": ["Frank Herbert"],
                    "first_publish_year": 1965,
                    "cover_i": 123456
                }
            ]
        }
        """

        let sut = try JSONDecoder().decode(
            OpenLibrarySearchResponseDTO.self,
            from: Data(json.utf8)
        )

        let work = try #require(sut.docs.first)

        #expect(sut.docs.count == 1)
        #expect(work.key == "/works/OL27448W")
        #expect(work.title == "Dune")
        #expect(work.authorNames == ["Frank Herbert"])
        #expect(work.firstPublishYear == 1965)
        #expect(work.coverID == 123_456)
    }

    @Test
    func decoding_whenOptionalFieldsAreMissing_preservesNilValues() throws {
        let json = """
        {
            "docs": [
                {
                    "key": "/works/OL27448W",
                    "title": "Dune"
                }
            ]
        }
        """

        let sut = try JSONDecoder().decode(
            OpenLibrarySearchResponseDTO.self,
            from: Data(json.utf8)
        )

        let work = try #require(sut.docs.first)

        #expect(work.key == "/works/OL27448W")
        #expect(work.title == "Dune")
        #expect(work.authorNames == nil)
        #expect(work.firstPublishYear == nil)
        #expect(work.coverID == nil)
    }

    @Test
    func decoding_whenDocumentsAreEmpty_returnsEmptyArray() throws {
        let json = """
        {
            "docs": []
        }
        """

        let sut = try JSONDecoder().decode(
            OpenLibrarySearchResponseDTO.self,
            from: Data(json.utf8)
        )

        #expect(sut.docs.isEmpty)
    }

    @Test
    func decoding_whenDocumentsAreMissing_throwsDecodingError() {
        let json = """
        {
            "numFound": 0
        }
        """

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(
                OpenLibrarySearchResponseDTO.self,
                from: Data(json.utf8)
            )
        }
    }
}
