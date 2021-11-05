//
//  MovieListRow.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct MovieListRow: View {
    let store: Store<MovieState, MovieAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .top) {
                if let url =  viewStore.movie.posterThumbnail {
                    RemoteImage(url: url)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 100)
                }
                VStack(alignment: .leading) {
                    Text(viewStore.movie.title)
                        .font(.headline)
                    
                    if let desc = viewStore.movie.overview {
                        Text(desc)
                            .lineLimit(5)
                            .font(.caption)
                    }
                    Image(systemName: viewStore.isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            viewStore.send(.toggleFavorite)
                        }
                    
                }
                Spacer()
            }
            .padding()
            .onTapGesture {
                viewStore.send(.showDetails(true))
            }
            .swipeActions {
                Button {
                    viewStore.send(.toggleFavorite)
                } label: {
                    Image(systemName: viewStore.isFavorite ? "heart.slash.fill" : "heart.fill")
                }
            }
            .sheet(isPresented: viewStore.binding(get: \.isDetailShown, send: MovieAction.showDetails)) {
                IfLetStore(store.scope(state: \.detail , action: MovieAction.detail), then: {
                    MovieDetailScreen(store:$0)
                })
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }
}

//struct MovieListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListRow(store: Store(
//            initialState: Movie.preview.first!,
//            reducer: movieReducer,
//            environment: MovieEnvironment()))
//    }
//}
