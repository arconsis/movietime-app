//
//  MovieListScreen.swift
//  MovieTime
//
//  Created by arconsis on 15.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Combine
import MovieApi

struct MovieListScreen: View {
    
    let store: Store<MovieListState, MovieListAction>
    
    var body: some View {
        
        WithViewStore(store) { viewStore in
            VStack(spacing: 0) {
                HStack {
                    Image(systemName:"magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Movie", text:viewStore.binding(
                                get: \.searchTerm,
                                send: MovieListAction.searchFieldChanged))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                Divider()
                ScrollView {
                    LazyVStack {
                        ForEach(viewStore.movies) { movie in
                            MovieListRow(movie: movie)
                        }
                    }
                }
            }
        }
    }
}

struct MovieListScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieListScreen(
            store: Store<MovieListState, MovieListAction>(
                initialState: MovieListState(
                    movies: Movie.preview
                ),
                reducer: movieListReducer,
                environment: MovieListEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    search: { _ -> AnyPublisher<[Movie], MovieApi.Error> in
                        return CurrentValueSubject(Movie.preview)
                            .eraseToAnyPublisher()
                    }
                    
                ))
        )
    }
}

struct MovieListState: Equatable {
    var searchTerm: String = ""
    var movies: [Movie] = []
}

enum MovieListAction: Equatable {
    case showMovies(Result<[Movie], MovieApi.Error>)
    case searchFieldChanged(String)
    case search(String)
}

struct MovieListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var search: (String) -> AnyPublisher<[Movie], MovieApi.Error>
}

let movieListReducer = Reducer<MovieListState, MovieListAction, MovieListEnvironment> { state, action, env in
    switch action {
    case let .searchFieldChanged(term):
        struct SearchDebounceId: Hashable {}
        
        state.searchTerm = term
    
        return Effect(value: .search(term))
            .debounce(
                id: SearchDebounceId(),
                for: 0.5,
                scheduler: env.mainQueue)
    case let .search(term):
        guard !term.isEmpty else {
            return Effect(value: .showMovies(.success([])))
        }
        return env.search(term)
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(MovieListAction.showMovies)
    case let .showMovies(.success(movies)):
        state.movies = movies
        return .none
    case .showMovies(.failure):
        state.movies = []
        return .none
    }

}
