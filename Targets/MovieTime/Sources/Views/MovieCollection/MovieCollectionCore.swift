//
//  MovieListCore.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import ComposableArchitecture
import Combine

struct MovieCollection: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var type: CollectionType
        var title: String {
            type.title
            
        }
        var currentPage = 1
        var lastPageReached = false
        var isLoadingMoreMovies = false
        var loadingMoreFailed = false
        var movieStates: IdentifiedArrayOf<MovieListEntry.State> = []
        
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
    
    enum Action: Equatable {
        case viewAppeared
        case showMovies(Result<[Movie], MovieServiceError>)
        case appendMovies(Result<[Movie], MovieServiceError>)
        case movie(movieId: Int, action: MovieListEntry.Action)
        case requestMovies(isFirstPage: Bool)
        case loadMore
    }
    
    @Dependency(\.movieService) var movieService
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
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
                    publisher = movieService.search(query: query, page: state.currentPage)
                case .nowPlaying:
                    publisher = movieService.movies(type: .nowPlaying, page: state.currentPage)
                case .popular:
                    publisher = movieService.movies(type: .popular, page: state.currentPage)
                case .topRated:
                    publisher = movieService.movies(type: .topRated, page: state.currentPage)
                }
                
                return publisher
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(isFirstPage ? Action.showMovies : Action.appendMovies)
            case let .showMovies(.success(movies)):
                state.movieStates = IdentifiedArrayOf<MovieListEntry.State>(uniqueElements: movies.map { MovieListEntry.State(movie: $0) })
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
                    state.movieStates.append(MovieListEntry.State(movie: movie))
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
        }
        .forEach(\.movieStates, action: /Action.movie(movieId:action:)) {
            MovieListEntry()
        }
    }
}
