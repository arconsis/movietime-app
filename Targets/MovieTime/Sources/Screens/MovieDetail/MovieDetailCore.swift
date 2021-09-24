//
//  MovieDetailCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import ComposableArchitecture
import MovieApi
import Combine
import CoreData

// MARK: - State
struct MovieDetailState: Equatable {
    var movie: Movie
    var isLoading: Bool = false
}

// MARK: - Actions
enum MovieDetailAction: Equatable {
    case viewAppeared
    case updateMovie(Result<Movie, MovieApi.Error>)
    case toggleFavorite
}

// MARK: - Environment
struct MovieDetailEnvironment {
    var load: (Int) -> AnyPublisher<Movie, MovieApi.Error>
}

// MARK: - Reducer
let movieDetailReducer = Reducer<MovieDetailState, MovieDetailAction, MovieDetailEnvironment> { state, action, env in
    switch action {
    case .viewAppeared:
        state.isLoading = true
        return env.load(state.movie.id)
            .receive(on: DispatchQueue.main)
            .catchToEffect()
            .map(MovieDetailAction.updateMovie)
    case .updateMovie(.success(let movie)):
        state.isLoading = false
        let isFavorite = state.movie.isFavorite
        state.movie = movie
        state.movie.isFavorite = isFavorite
        return .none
    case .updateMovie(.failure):
        state.isLoading = false
            // show update error?
        return .none
    case .toggleFavorite:
        state.movie.isFavorite.toggle()
        return .none
    }
}
