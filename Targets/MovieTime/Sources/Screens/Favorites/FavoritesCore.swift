//
//  FavoritesCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct FavoritesState: Equatable {
    var movies: [Movie] = []
}

enum FavoritesAction {
    case toggleFavorite(Movie)
    case movie(index: Int, action: MovieAction)
}

struct FavoritesEnvironment {
    
}

let favoritesReducer = Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment>.combine(
    movieReducer.forEach(
        state: \.movies,
        action: /FavoritesAction.movie(index:action:),
        environment: { _ in MovieEnvironment()}),
    
    Reducer { state, action, env in
        switch action {
        case .movie(index: let index, action: MovieAction.toggleFavorite):
            return Effect(value: .toggleFavorite(state.movies[index]))
        case .toggleFavorite(let movie):
            if let index = state.movies.firstIndex(where: { $0.id == movie.id }) {
                state.movies.remove(at: index)
            } else {
                state.movies.append(movie)
            }
            return .none
        }
}
)
