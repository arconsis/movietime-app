//
//  MovieDetailCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import ComposableArchitecture

struct MovieDetail: ReducerProtocol {
    // MARK: - State
    struct State: Equatable {
        var movie: Movie
        var isFavorite: Bool = false
        var isLoading: Bool = false
    }
    
    // MARK: - Actions
    enum Action: Equatable {
        case viewAppeared
        case updateMovie(Result<Movie, MovieServiceError>)
        case updateFavorite(Result<Bool, Never>)
        case toggleFavorite
    }
    
    @Dependency(\.favoriteService) var favoriteService
    @Dependency(\.movieService) var movieService
    @Dependency(\.mainQueue) var mainQueue
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewAppeared:
            state.isLoading = true
            state.isFavorite = favoriteService.isFavorite(movieId: state.movie.id)
            return .merge(
                movieService.movie(withId: state.movie.id)
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.updateMovie),
                favoriteService.isFavorite(movieId: state.movie.id)
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.updateFavorite)
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
            favoriteService.toggle(movie: state.movie)
            return .none
        }
    }
    
}
