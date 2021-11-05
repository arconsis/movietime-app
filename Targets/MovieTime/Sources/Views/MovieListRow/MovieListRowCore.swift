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
    var isDetailShown: Bool = false
    var detail: MovieDetailState?
    
    var id: Int {
        return movie.id
    }
}

enum MovieAction: Equatable {
    case toggleFavorite
    case detail(MovieDetailAction)
    case showDetails(Bool)
}

struct MovieEnvironment {
    var load: (Int) -> AnyPublisher<Movie, MovieDetailError>
}

let movieReducer = Reducer<MovieState, MovieAction, MovieEnvironment>.combine(
    movieDetailReducer.optional().pullback(
        state: \.detail,
        action: /MovieAction.detail,
        environment: { MovieDetailEnvironment(load: $0.load) } ),

 Reducer { state, action, _ in
    switch action {
    case .toggleFavorite:
        state.movie.isFavorite.toggle()
        return .none
    case .showDetails(let isShowing):
        state.isDetailShown = isShowing
        state.detail = MovieDetailState(movie: state.movie)
        return .none
    case .detail(.toggleFavorite):
        return Effect(value: .toggleFavorite)
    default: return .none
    }
})
