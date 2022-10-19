//
//  MovieListCore.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import ComposableArchitecture

struct MovieListEntry: ReducerProtocol {
    
    struct State: Equatable, Identifiable {
        var movie: Movie
        var isFavorite: Bool = false
        var isDetailShown: Bool = false
        var detail: MovieDetail.State?
        
        var id: Int {
            return movie.id
        }
    }
    
    enum Action: Equatable {
        case viewAppeared
        case updateFavorite(Result<Bool, Never>)
        case toggleFavorite
        case detail(MovieDetail.Action)
        case showDetails(Bool)
    }
    
    @Dependency(\.favoriteService) var favoriteService
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewAppeared:
                state.isFavorite = favoriteService.isFavorite(movieId: state.movie.id)
                return favoriteService.isFavorite(movieId: state.movie.id)
                        .receive(on: mainQueue)
                        .catchToEffect()
                        .map(Action.updateFavorite)
            case .toggleFavorite:
                favoriteService.toggle(movie: state.movie)
                return .none
            case .updateFavorite(.success(let isFavorite)):
                state.isFavorite = isFavorite
                return .none
            case .showDetails(let isShowing):
                state.isDetailShown = isShowing
                state.detail = MovieDetail.State(movie: state.movie)
                return .none
            default: return .none
            }
        }
        .ifLet(\.detail, action: /Action.detail) {
            MovieDetail()
        }
    }
    
}
