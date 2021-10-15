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
import MovieApi
import IdentifiedCollections

struct FavoritesState: Equatable {
    var movieStates: IdentifiedArrayOf<MovieState> = []
}

enum FavoritesAction {
    case toggleFavorite(Movie)
    case movie(index: Int, action: MovieAction)
}

struct FavoritesEnvironment {
    var load: (Int) -> AnyPublisher<Movie, MovieApiError>    
}

let favoritesReducer = Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment>.combine(
    movieReducer.forEach(
        state: \.movieStates,
        action: /FavoritesAction.movie(index:action:),
        environment: { MovieEnvironment(load: $0.load) }),
    
    Reducer { state, action, env in
        switch action {
        case .movie(index: let index, action: MovieAction.toggleFavorite):
            guard let movie = state.movieStates[id: index]?.movie else { return .none }
            return Effect(value: .toggleFavorite(movie))
        case .toggleFavorite(let movie):
            if let movie = state.movieStates[id: movie.id] {
                state.movieStates.remove(id: movie.id)
            } else {
                state.movieStates.append(MovieState(movie: movie))
            }
            return .none
        default: return .none
        }
}
)
