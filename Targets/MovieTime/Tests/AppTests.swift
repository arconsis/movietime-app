import Foundation
import XCTest
import ComposableArchitecture
import Combine

@testable import MovieTime
import MovieApi

final class MovieTimeTests: XCTestCase {
    
    let scheduler = DispatchQueue.test

    func createEnvironment(movies: [Movie] = []) -> MovieListEnvironment {
        MovieListEnvironment(
            mainQueue: scheduler.eraseToAnyScheduler(),
            search: { _ in Effect(value: movies).eraseToAnyPublisher() },
            load: { _ in Fail(error: MovieApi.Error.detail).eraseToAnyPublisher() }
        )
    }
    
    func createEnvironment(movies: @escaping (String) -> [Movie]) -> MovieListEnvironment {
        MovieListEnvironment(
            mainQueue: scheduler.eraseToAnyScheduler(),
            search: { query in Effect(value: movies(query)).eraseToAnyPublisher() },
            load: { _ in Fail(error: MovieApi.Error.detail).eraseToAnyPublisher() }
        )
    }
    
    func test_noSearchResults() {
        
        let store = TestStore(
            initialState: MovieListState(),
            reducer: movieListReducer,
            environment: createEnvironment()
        )
        
        store.send(MovieListAction.searchFieldChanged("test")) {
            $0.searchTerm = "test"
        }
        
        scheduler.advance(by: 0.5)
            
        store.receive(MovieListAction.search("test"))
        
        store.receive(MovieListAction.showMovies(.success([]))) {
            $0.movieStates = []
        }
    }
    
    func test_noSearchTerm() {
        
        let store = TestStore(
            initialState: MovieListState(),
            reducer: movieListReducer,
            environment: createEnvironment(
                movies: { _ in
                    XCTFail("Api should not be called here")
                    return []
                }
            )
        )
        
        store.send(MovieListAction.searchFieldChanged("")) {
            $0.searchTerm = ""
        }
        
        scheduler.advance(by: 0.5)
            
        store.receive(MovieListAction.search(""))
        
        store.receive(MovieListAction.showMovies(.success([]))) {
            $0.movieStates = []
        }
    }
}
