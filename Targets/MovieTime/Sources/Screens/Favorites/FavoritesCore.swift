//
//  FavoritesCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Combine
import IdentifiedCollections

struct FavoritesState: Equatable {
    var movieStates: IdentifiedArrayOf<MovieState> = []
}

enum FavoritesAction {
    case viewAppeared
    case updateMovies(Result<Set<Movie>, Never>)
    case movie(index: Int, action: MovieAction)
    case setMovies(Set<Movie>)
}

let favoritesReducer = Reducer<FavoritesState, FavoritesAction, AppEnvironment>.combine(
    movieReducer.forEach(
        state: \.movieStates,
        action: /FavoritesAction.movie(index:action:),
        environment: { $0 }),
    
    Reducer { state, action, env in
        switch action {
        case .viewAppeared:
            return Effect(value: .setMovies(env.favoriteService.favorites()))
            
        case .updateMovies(.success(let movies)):
            return Effect(value: .setMovies(movies))
        case .setMovies(let movieSet):
            let sortedMovies = movieSet.sorted { $0.title < $1.title}
            state.movieStates = IdentifiedArrayOf(uniqueElements: sortedMovies.map { MovieState(movie: $0)})
            return .none
        case .movie(let index, .updateFavorite):
            return Effect(value: .setMovies(env.favoriteService.favorites()))
        default: return .none
        }
    }
)
