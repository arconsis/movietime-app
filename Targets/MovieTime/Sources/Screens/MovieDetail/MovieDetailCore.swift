//
//  MovieDetailCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine
import CoreData

// MARK: - State
struct MovieDetailState: Equatable {
    var movie: Movie
    var isFavorite: Bool = false
    var isLoading: Bool = false
}

// MARK: - Actions
enum MovieDetailAction: Equatable {
    case viewAppeared
    case updateMovie(Result<Movie, MovieServiceError>)
    case updateFavorite(Result<Bool, Never>)
    case toggleFavorite
}


// MARK: - Reducer
let movieDetailReducer = Reducer<MovieDetailState, MovieDetailAction, AppEnvironment> { state, action, env in
    switch action {
    case .viewAppeared:
        state.isLoading = true
        state.isFavorite = env.favoriteService.isFavorite(movieId: state.movie.id)
        return .merge(
            env.movieService.movie(withId: state.movie.id)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MovieDetailAction.updateMovie),
            env.favoriteService.isFavorite(movieId: state.movie.id)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MovieDetailAction.updateFavorite)
        )
    case .updateFavorite(.success(let isFavorite)):
        state.isFavorite = isFavorite
        return .none
    case .updateMovie(.success(let movie)):
        state.isLoading = false
        state.movie = movie
        return .none
    case .updateMovie(.failure):
        state.isLoading = false
            // show update error?
        return .none
    case .toggleFavorite:
        env.favoriteService.toggle(movie: state.movie)
        return .none
    }
}
