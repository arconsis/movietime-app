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
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewStore.movie.title)
                            .font(.title)
                            .padding(.top, 300)

                        if !viewStore.movie.tagline.isEmpty {
                            Text(viewStore.movie.tagline)
                                .font(Font.subheadline)
                        }
                        
                        HStack(spacing: 16) {
                            Label {
                                Text("\(viewStore.movie.runtime) min")
                            } icon: {
                                Image(systemName: "clock").foregroundColor(.yellow)
                            }
                            
                            if let date = viewStore.movie.releaseDate {
                                Label {
                                    Text(date, style: .date)
                                } icon: {
                                    Image(systemName: "calendar").foregroundColor(.yellow)
                                }
                            }
                            
                            Label {
                                Text("\(viewStore.movie.voteAverage, format: .number)")
                            } icon: {
                                Image(systemName: "star").foregroundColor(.yellow)
                            }

                        }
                        .font(Font.caption)
                        .padding(.vertical, 8)
                        
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
                            Label {
                                Text(viewStore.movie.isFavorite ? "Remove from favorites" : "Add to favorites")
                                    .font(.caption)
                                    .bold()
                                    .underline()
                            } icon: {
                                Image(systemName: viewStore.movie.isFavorite ? "heart.fill" : "heart")
                            }
                        }
                        .foregroundColor(.yellow)
                        .padding(.top, 20)
                        .onTapGesture {
                            viewStore.send(.toggleFavorite)
                        }
                        
                        Text(viewStore.movie.overview ?? "")
                            .font(.body)
                            .padding(.top, 20)
                        
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

