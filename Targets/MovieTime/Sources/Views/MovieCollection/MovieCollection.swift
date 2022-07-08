//
//  MovieCollection.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct MovieCollection: View {
    let store: Store<MovieCollectionState, MovieCollectionAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                Text(viewStore.title)
                    .font(.headline)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    LazyHStack() {
                            ForEachStore(store.scope(state: \.movieStates, action: MovieCollectionAction.movie(movieId:action:)),
                                         content: MovieCollectionElement.init(store:))
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }
}

//struct MovieCollection_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieCollection(store: Store(
//            initialState: Movie.preview.first!,
//            reducer: movieReducer,
//            environment: MovieEnvironment()))
//    }
//}
