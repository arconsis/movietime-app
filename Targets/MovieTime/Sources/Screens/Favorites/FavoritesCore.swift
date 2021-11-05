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
}

let favoritesReducer = Reducer<FavoritesState, FavoritesAction, AppEnvironment>.combine(
    movieReducer.forEach(
        state: \.movieStates,
        action: /FavoritesAction.movie(index:action:),
        environment: { $0 }),
    
    Reducer { state, action, env in
        switch action {
        case .viewAppeared:
            return env.favoriteService.favorites
                .receive(on: env.mainQueue)
                .catchToEffect()
                .map(FavoritesAction.updateMovies)
        case .updateMovies(.success(let movies)):
            state.movieStates = IdentifiedArrayOf(uniqueElements: movies.map { MovieState(movie: $0)})
            return .none
        default: return .none
        }
}
)
