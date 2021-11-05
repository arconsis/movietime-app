//
//  MovieListCore.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct MovieState: Equatable, Identifiable {
    var movie: Movie
    var isFavorite: Bool = false
    var isDetailShown: Bool = false
    var detail: MovieDetailState?
    
    var id: Int {
        return movie.id
    }
}

enum MovieAction: Equatable {
    case viewAppeared
    case updateFavorite(Result<Bool, Never>)
    case toggleFavorite
    case detail(MovieDetailAction)
    case showDetails(Bool)
}

let movieReducer = Reducer<MovieState, MovieAction, AppEnvironment>.combine(
    movieDetailReducer.optional().pullback(
        state: \.detail,
        action: /MovieAction.detail,
        environment: { $0 } ),

 Reducer { state, action, env in
    switch action {
    case .viewAppeared:
        return env.favoriteService.isFavorite(movieId: state.movie.id)
                .receive(on: DispatchQueue.main)
                .catchToEffect()
                .map(MovieAction.updateFavorite)
    case .toggleFavorite:
        state.isFavorite = env.favoriteService.toggle(movie: state.movie)
        return .none
    case .updateFavorite(.success(let isFavorite)):
        state.isFavorite = isFavorite
        return .none
    case .showDetails(let isShowing):
        state.isDetailShown = isShowing
        state.detail = MovieDetailState(movie: state.movie)
        return .none
    default: return .none
    }
})
