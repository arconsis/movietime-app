//
//  MovieDetailScreen.swift
//  MovieTime
//
//  Created by arconsis on 15.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Combine
import MovieApi

struct MovieDetailScreen: View {
    
    let store: Store<MovieDetailState, MovieDetailAction>
    
    var body: some View {
        
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    if let overview = viewStore.movie.overview {
                        Text(overview).padding()
                    }
                    if viewStore.state.isLoading {
                        Text("updating")
                    }
                    if let date = viewStore.state.movie.releaseDate {
                        Text(date, style: .date)
                    }
                    if let url = viewStore.movie.posterUrl {
                        RemoteImage(url: url)
                            .frame(maxWidth: .infinity)
                    }
                    Text(viewStore.movie.title)
                }
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
            .navigationTitle(viewStore.movie.title)
        }
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailScreen(
            store: Store(initialState: MovieDetailState(movie: Movie.preview.first!),
                         reducer: movieDetailReducer,
                         environment: MovieDetailEnvironment(load: { movieId in
            CurrentValueSubject(Movie.preview.first!)
            .eraseToAnyPublisher() } )))
    }
}

extension MovieDetailScreen {
    static func detail(for movie: Movie) -> MovieDetailScreen {
        let environment = MovieDetailEnvironment(
            load: { movieId in
            MovieApi.detail(movieId:movieId)
                .receive(on: DispatchQueue.main)
                .map { Movie(movie: $0) }
                .eraseToAnyPublisher()
            
        })
        return MovieDetailScreen(
            store: Store(initialState: MovieDetailState(movie: movie),
                         reducer: movieDetailReducer,
                         environment: environment))
    }
}

