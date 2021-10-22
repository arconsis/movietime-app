//
//  MovieServiceTests.swift
//  MovieTimeTests
//
//  Created by arconsis on 15.10.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import XCTest
import Combine
@testable import MovieTime
import MovieApi
import Mockingbird

class MovieServiceTests: XCTestCase {
    
    var sut: AppMovieService!
    var cancellable: Set<AnyCancellable> = []
    
    var mockApiService = mock(MovieApiService.self)

    override func setUpWithError() throws {
        sut = AppMovieService(api: mockApiService)
    }

    override func tearDownWithError() throws {
        reset(mockApiService)
    }

    func testSetup() throws {
        XCTAssertNotNil(sut)
    }
    
    func testSearchWithResult() {
        
        given(mockApiService.search(query: any())).will { _ in
            Just([ MovieDto(id: 42) ]).setFailureType(to: MovieApiError.self).eraseToAnyPublisher()
        }
        
        let exp = expectation(description: "search")
        
        sut.search(query: "Marvel")
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("No error expected")
                }
                exp.fulfill()
            } receiveValue: { movies in
                XCTAssertFalse(movies.isEmpty)
                XCTAssertEqual(movies.first?.id, 42)
            }.store(in: &cancellable)

        wait(for: [exp], timeout: 1)
        
        verify(mockApiService.search(query: "Marvel")).wasCalled(1)
    }
    
    func testSearchWithNoResult() {
        
        given(mockApiService.search(query: any())).will { _ in
            Just([]).setFailureType(to: MovieApiError.self).eraseToAnyPublisher()
        }
        
        let exp = expectation(description: "search")
        
        sut.search(query: "Marvel")
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("No error expected")
                }
                exp.fulfill()
            } receiveValue: { movies in
                XCTAssertTrue(movies.isEmpty)
            }.store(in: &cancellable)

        wait(for: [exp], timeout: 1)
        
        verify(mockApiService.search(query: "Marvel")).wasCalled(1)
    }
    
    func testEmptySearchTerm() {
        
        given(mockApiService.search(query: any())).will { _ in
            Just([ MovieDto(id: 42) ]).setFailureType(to: MovieApiError.self).eraseToAnyPublisher()
        }

        let exp = expectation(description: "search")
        
        sut.search(query: "")
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTAssertTrue(error == .invalidSearchTerm)
                } else {
                    XCTFail("Error expected")
                }
                exp.fulfill()
            } receiveValue: { _ in
                XCTFail("No movies expected")
            }.store(in: &cancellable)

        wait(for: [exp], timeout: 1)
        
        verify(mockApiService.search(query: any())).wasNeverCalled()
    }
    
    func testSearchWithApiError() {
        
        given(mockApiService.search(query: any())).will { _ in
            Fail(error: MovieApiError.search).eraseToAnyPublisher()
        }
        
        let exp = expectation(description: "search")
        
        sut.search(query: "Marvel")
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTAssertTrue(error == .failed)
                } else {
                    XCTFail("Error expected")
                }
                exp.fulfill()
            } receiveValue: { _ in
                XCTFail("No movies expected")
            }.store(in: &cancellable)

        wait(for: [exp], timeout: 1)
        
        verify(mockApiService.search(query: "Marvel")).wasCalled(1)
    }
    
    
}
