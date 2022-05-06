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

struct MovieCollectionState: Equatable, Identifiable {
    var type: CollectionType
    var title: String {
        type.title
        
    }
    var currentPage = 1
    var lastPageReached = false
    var isLoadingMoreMovies = false
    var loadingMoreFailed = false
    var movieStates: IdentifiedArrayOf<MovieState> = []
    
    var id: String {
        return title
    }
    
    enum CollectionType: Equatable {
        case popular
        case nowPlaying
        case topRated
        case custom(title: String, query: String)
        
        var title: String {
            switch self {
            case .popular:
                return "Most Popular Movies"
            case .nowPlaying:
                return "Movies in Theaters"
            case .topRated:
                return "Best Movies of all time"
            case .custom(title: let title, query: _):
                return title
            }
        }
    }
}

enum MovieCollectionAction: Equatable {
    case viewAppeared
    case showMovies(Result<[Movie], MovieServiceError>)
    case appendMovies(Result<[Movie], MovieServiceError>)
    case movie(movieId: Int, action: MovieAction)
    case requestMovies(isFirstPage: Bool)
    case loadMore
}

let movieCollectionReducer = Reducer<MovieCollectionState, MovieCollectionAction, AppEnvironment>.combine(
    movieReducer.forEach(
        state: \.movieStates,
        action: /MovieCollectionAction.movie(movieId:action:),
        environment: { $0 }),
Reducer { state, action, env in
    switch action {
    case .viewAppeared:
        state.currentPage = 1
        state.lastPageReached = false
        state.loadingMoreFailed = false
        return Effect(value: .requestMovies(isFirstPage: true))
    case .loadMore:
        guard !state.lastPageReached, !state.isLoadingMoreMovies else {
            return .none
        }
        state.currentPage += 1
        state.isLoadingMoreMovies = true
        state.loadingMoreFailed = false
        
        return Effect(value: .requestMovies(isFirstPage: false))

    case .requestMovies(let isFirstPage):
        let publisher: AnyPublisher<[Movie], MovieServiceError>
        
        switch state.type {
        case .custom(title: _, query: let query):
            publisher = env.movieService.search(query: query, page: state.currentPage)
        case .nowPlaying:
            publisher = env.movieService.movies(type: .nowPlaying, page: state.currentPage)
        case .popular:
            publisher = env.movieService.movies(type: .popular, page: state.currentPage)
        case .topRated:
            publisher = env.movieService.movies(type: .topRated, page: state.currentPage)
        }
        
        return publisher
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(isFirstPage ? MovieCollectionAction.showMovies : MovieCollectionAction.appendMovies)
    case let .showMovies(.success(movies)):
        state.movieStates = IdentifiedArrayOf<MovieState>(uniqueElements: movies.map { MovieState(movie: $0) })
        return .none
    case .showMovies(.failure):
        state.movieStates = []
        return .none
        
    case let .appendMovies(.success(movies)):
        guard !movies.isEmpty else {
            state.lastPageReached = true
            return .none
        }
        state.isLoadingMoreMovies = false
        movies.forEach { movie in
            state.movieStates.append(MovieState(movie: movie))
        }
        return .none
    case .appendMovies(.failure):
        state.isLoadingMoreMovies = false
        state.loadingMoreFailed = true
        return .none
    case .movie(movieId: let movieId, action: .viewAppeared):
        let movieIdToTriggerLoading = state.movieStates[max(0,state.movieStates.count - 3)].id
        
        if movieIdToTriggerLoading == movieId {
            return Effect(value: .loadMore)
        } else {
            return .none
        }
    default: return .none
    }
})
