//
//  DemoScreen.swift
//  MovieTime
//
//  Created by arconsis on 15.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Combine
import MovieApi

struct DemoScreen: View {
    
    let store: Store<MovieListState, MovieListAction>
    
    var body: some View {
        
        WithViewStore(store) { viewStore in
            List(viewStore.movies) { movie in
                Text(movie.title)
            }.onAppear {
                viewStore.send(.onStart)
            }
        }
    }
}

struct DemoScreen_Previews: PreviewProvider {
    static var previews: some View {
        DemoScreen(
            store: Store<MovieListState, MovieListAction>(
                initialState: MovieListState(),
                reducer: movieListReducer,
                environment: MovieListEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    search: { _ -> Effect<[Movie], MovieApi.Error> in
                        return CurrentValueSubject([Movie(title: "My Movie", id: 1)]).eraseToEffect()
                    }
                    
                ))
        )
    }
}

struct MovieListState: Equatable {
    var movies: [Movie] = []
}

enum MovieListAction: Equatable {
    case showMovies(Result<[Movie], MovieApi.Error>)
    case onStart
}

struct MovieListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var search: (String) -> AnyPublisher<[Movie], MovieApi.Error>
}

let movieListReducer = Reducer<MovieListState, MovieListAction, MovieListEnvironment> { state, action, env in
    switch action {
    case .onStart:
        return env.search("Marvel")
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(MovieListAction.showMovies)
    case let .showMovies(.success(movies)):
        state.movies = movies
        return .none
    case .showMovies(.failure):
        return .none
    }

}.debug()
