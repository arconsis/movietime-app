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
    let store: Store<Movie, MovieAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .top) {
                if let url =  viewStore.posterUrl {
                    RemoteImage(url: url)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 100)
                }
                VStack(alignment: .leading) {
                    Text(viewStore.title)
                        .font(.headline)
                    
                    if let desc = viewStore.overview {
                        Text(desc)
                            .lineLimit(5)
                            .font(.caption)
                    }
                    Image(systemName: viewStore.isFavorite ? "heart.fill" : "heart")
                }
                Spacer()
            }.padding()
                .swipeActions {
                    Button {
                        viewStore.send(.toggleFavorite)
                    } label: {
                        Image(systemName: viewStore.isFavorite ? "heart.slash.fill" : "heart.fill")
                    }

                }
        }
    }
}

struct MovieListRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieListRow(store: Store(
            initialState: Movie.preview.first!,
            reducer: movieReducer,
            environment: MovieEnvironment()))
    }
}
