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
    var movieService: MovieService
    var favoriteService: FavoriteService
}


let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    movieListReducer.pullback(
        state: \.movieList,
        action: /AppAction.movieList,
        environment: { $0 }),
    
    favoritesReducer.pullback(
        state: \.favorites,
        action: /AppAction.favorites,
        environment: { $0}),
    
    .init { state, action ,_ in
        switch action {
        
        default:
            return .none
        }
    }
)
