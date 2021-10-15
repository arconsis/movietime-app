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

class MovieServiceTests: XCTestCase {
    
    class MovieApiMock: MovieApiService {
        
        var movies: [MovieDto] = []
        
        func search(query: String) -> AnyPublisher<[MovieDto], MovieApiError> {
            Just(movies).setFailureType(to: MovieApiError.self).eraseToAnyPublisher()
        }
        
        func detail(movieId: Int) -> AnyPublisher<MovieDto, MovieApiError> {
            guard let movie = movies.first else {
                return Fail(error: MovieApiError.search).eraseToAnyPublisher()
            }
            return Just(movie).setFailureType(to: MovieApiError.self).eraseToAnyPublisher()
        }
    }
    
    var sut: AppMovieService!
    var cancellable: Set<AnyCancellable> = []
    var mock: MovieApiMock = MovieApiMock()

    override func setUpWithError() throws {
        sut = AppMovieService(api: mock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetup() throws {
        XCTAssertNotNil(sut)
    }
    
    func testSearch() {
        
        mock.movies = [ MovieDto(id: 42) ]
        
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
    }
}
