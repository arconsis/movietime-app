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
    var search: (String) -> AnyPublisher<[Movie], MovieApi.Error>
    var load: (Int) -> AnyPublisher<Movie, MovieApi.Error>
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
            let movie = state.movieList.movieStates[index].movie
            return Effect(value: .favorites(action: .toggleFavorite(movie)))
        case AppAction.favorites(action: FavoritesAction.toggleFavorite(let movie)):
            if let index = state.movieList.movieStates.firstIndex(where: { $0.id == movie.id }) {
                state.movieList.movieStates[index].movie.isFavorite = movie.isFavorite
            }
            return .none
        case AppAction.movieList(action: MovieListAction.showMovies):
            state.favorites.movieStates.forEach { favorite in
                if let index = state.movieList.movieStates.firstIndex(where: { $0.id == favorite.id }) {
                    state.movieList.movieStates[index].movie.isFavorite = true
                }
            }
            
            return .none
        default:
            return .none
        }
    }
)
