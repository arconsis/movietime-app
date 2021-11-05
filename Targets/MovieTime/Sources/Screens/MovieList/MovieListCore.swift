//
//  MovieListCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine

// MARK: - State
struct MovieListState: Equatable {
    var searchTerm: String = ""
    var movieStates: IdentifiedArrayOf<MovieState> = []
}

// MARK: - Actions
enum MovieListAction: Equatable {
    case showMovies(Result<[Movie], MovieSearchError>)
    case searchFieldChanged(String)
    case search(String)
    case movie(index: Int, action: MovieAction)
}


// MARK: - Reducer
let movieListReducer = Reducer<MovieListState, MovieListAction, AppEnvironment>.combine(
    movieReducer.forEach(
        state: \.movieStates,
        action: /MovieListAction.movie(index:action:),
        environment: { $0 }),
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
        return env.movieService.search(query: term)
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(MovieListAction.showMovies)
    case let .showMovies(.success(movies)):
        state.movieStates = IdentifiedArrayOf<MovieState>(uniqueElements: movies.map { MovieState(movie: $0) })
        return .none
    case .showMovies(.failure):
        state.movieStates = []
        return .none
    default: return .none
    }

})
