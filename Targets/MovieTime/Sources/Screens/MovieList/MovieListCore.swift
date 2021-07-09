//
//  MovieListCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import ComposableArchitecture
import MovieApi
import Combine

// MARK: - State
struct MovieListState: Equatable {
    var searchTerm: String = ""
    var movies: [Movie] = []
}

// MARK: - Actions
enum MovieListAction: Equatable {
    case showMovies(Result<[Movie], MovieApi.Error>)
    case searchFieldChanged(String)
    case search(String)
    case movie(index: Int, action: MovieAction)
}

// MARK: - Environment
struct MovieListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var search: (String) -> AnyPublisher<[Movie], MovieApi.Error>
}

// MARK: - Reducer
let movieListReducer = Reducer<MovieListState, MovieListAction, MovieListEnvironment>.combine(
    movieReducer.forEach(
        state: \.movies,
        action: /MovieListAction.movie(index:action:),
        environment: { _ in MovieEnvironment()}),
Reducer { state, action, env in
    switch action {
    case let .searchFieldChanged(term):
        struct SearchDebounceId: Hashable {}
        
        state.searchTerm = term
    
        return Effect(value: .search(term))
            .debounce(
                id: SearchDebounceId(),
                for: 0.5,
                scheduler: env.mainQueue)
    case let .search(term):
        guard !term.isEmpty else {
            return Effect(value: .showMovies(.success([])))
        }
        return env.search(term)
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(MovieListAction.showMovies)
    case let .showMovies(.success(movies)):
        state.movies = movies
        return .none
    case .showMovies(.failure):
        state.movies = []
        return .none
    case let .movie(index: movieId, action: .toggleFavorite):
        return .none
    }

})
