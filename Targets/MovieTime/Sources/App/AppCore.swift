//
//  AppCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture
import MovieApi

struct AppState: Equatable {
    var movieList: MovieListState = MovieListState()
    var favorites: FavoritesState = FavoritesState()
}

enum AppAction {
    case movieList(action: MovieListAction)
    case favorites(action: FavoritesAction)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var search: (String) -> AnyPublisher<[Movie], MovieSearchError>
    var load: (Int) -> AnyPublisher<Movie, MovieApiError>
}

private extension MovieListEnvironment {
    init(env: AppEnvironment) {
        mainQueue = env.mainQueue
        search = env.search
        load = env.load
    }
}

private extension FavoritesEnvironment {
    init(env: AppEnvironment) {
        load = env.load
    }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    movieListReducer.pullback(
        state: \.movieList,
        action: /AppAction.movieList,
        environment: MovieListEnvironment.init),
    
    favoritesReducer.pullback(
        state: \.favorites,
        action: /AppAction.favorites,
        environment: FavoritesEnvironment.init),
    
    .init { state, action ,_ in
        switch action {
        case AppAction.movieList(action: MovieListAction.movie(index: let index, action: MovieAction.toggleFavorite)):
            guard let movie = state.movieList.movieStates[id: index]?.movie else { return .none }
            return Effect(value: .favorites(action: .toggleFavorite(movie)))
        case AppAction.favorites(action: FavoritesAction.toggleFavorite(let movie)):
            state.movieList.movieStates[id: movie.id]?.movie.isFavorite = movie.isFavorite
            return .none
        case AppAction.movieList(action: MovieListAction.showMovies):
            state.favorites.movieStates.forEach { favorite in
                state.movieList.movieStates[id: favorite.id]?.movie.isFavorite = true
            }
            
            return .none
        default:
            return .none
        }
    }
)
