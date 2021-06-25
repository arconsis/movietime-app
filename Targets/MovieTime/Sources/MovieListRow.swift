//
//  MovieListRow.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

enum MovieAction: Equatable {
    case toggleFavorite
}

struct MovieEnvironment {}

let movieReducer = Reducer<Movie, MovieAction, MovieEnvironment> { movie, action, _ in
    switch action {
    case .toggleFavorite:
        movie.isFavorite.toggle()
        return .none
    }
}


struct MovieListRow: View {
    let store: Store<Movie, MovieAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .top) {
                if let url =  viewStore.posterUrl {
                    AsyncImage(url: url, content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    }, placeholder: {
                        Color.green
                            .aspectRatio(3/4, contentMode: .fit)
                    })
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
