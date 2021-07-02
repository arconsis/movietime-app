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
}

private extension MovieListEnvironment {
    init(env: AppEnvironment) {
        mainQueue = env.mainQueue
        search = env.search
    }
}

private extension FavoritesEnvironment {
    init(env: AppEnvironment) {}
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
    
    .init { _, _ ,_ in
        return .none
    }
)
