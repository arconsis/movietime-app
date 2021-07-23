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
            ZStack {
                VStack {
                    GeometryReader { reader in
                        if let url = viewStore.movie.backdropUrl {
                            RemoteImage(url: url)
                                .aspectRatio(contentMode: .fill)
                                .mask(
                                    LinearGradient(
                                        colors: [
                                            .white,
                                            .white,
                                            .white,
                                            .white.opacity(0)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom)
                                )
                                
                                .frame(width: reader.size.width, height: 400, alignment: .center)
                        }
                    }
                    Spacer()
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(viewStore.movie.title)
                                .font(.title)
                                .padding(.top, 300)
                            
                            Spacer()
                        }
                        
                        HStack {
                            ForEach(viewStore.movie.genres, id: \.self) { genre in
                                Text(genre)
                                    .font(.caption)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(10)
                                
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewStore.movie.overview ?? "")
                                .font(.body)
                                .padding(.top, 20)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                }
            }
            .background(.black)
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }.ignoresSafeArea(edges: .top)

        
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

