//
//  FavoritesCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import ComposableArchitecture

struct Favorites: ReducerProtocol {
    struct State: Equatable {
        var movieStates: IdentifiedArrayOf<MovieListEntry.State> = []
    }
    
    enum Action {
        case viewAppeared
        case updateMovies(Result<Set<Movie>, Never>)
        case movie(index: Int, action: MovieListEntry.Action)
        case setMovies(Set<Movie>)
    }
    
    @Dependency(\.favoriteService) var favoriteService
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewAppeared:
                return Effect(value: .setMovies(favoriteService.favorites()))
                
            case .updateMovies(.success(let movies)):
                return Effect(value: .setMovies(movies))
            case .setMovies(let movieSet):
                let sortedMovies = movieSet.sorted { $0.title < $1.title}
                state.movieStates = IdentifiedArrayOf(uniqueElements: sortedMovies.map { MovieListEntry.State(movie: $0)})
                return .none
            case .movie(_, .updateFavorite):
                return Effect(value: .setMovies(favoriteService.favorites()))
            default: return .none
            }
        }
        .forEach(\.movieStates, action: /Favorites.Action.movie(index:action:)) {
            MovieListEntry()
        }
    }
}
