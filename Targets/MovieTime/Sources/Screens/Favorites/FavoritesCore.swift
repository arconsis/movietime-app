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

struct FavoritesState: Equatable {
    var movieStates: [MovieState] = []
}

enum FavoritesAction {
    case toggleFavorite(Movie)
    case movie(index: Int, action: MovieAction)
}

struct FavoritesEnvironment {
    var load: (Int) -> AnyPublisher<Movie, MovieApi.Error>    
}

let favoritesReducer = Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment>.combine(
    movieReducer.forEach(
        state: \.movieStates,
        action: /FavoritesAction.movie(index:action:),
        environment: { MovieEnvironment(load: $0.load) }),
    
    Reducer { state, action, env in
        switch action {
        case .movie(index: let index, action: MovieAction.toggleFavorite):
            return Effect(value: .toggleFavorite(state.movieStates[index].movie))
        case .toggleFavorite(let movie):
            if let index = state.movieStates.firstIndex(where: { $0.id == movie.id }) {
                state.movieStates.remove(at: index)
            } else {
                state.movieStates.append(MovieState(movie: movie))
            }
            return .none
        default: return .none
        }
}
)
