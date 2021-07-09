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
                List {
                    ForEachStore(store.scope(state: \.movies, action: MovieListAction.movie(index:action:)),
                                 content: MovieListRow.init(store:))
                }.onAppear {
                    if viewStore.searchTerm.isEmpty {
                        viewStore.send(.searchFieldChanged("Marvel"))
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
