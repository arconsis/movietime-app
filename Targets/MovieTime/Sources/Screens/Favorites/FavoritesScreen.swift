//
//  FavoritesScreen.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesScreen: View {
    
    let store: Store<FavoritesState, FavoritesAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.movieStates.isEmpty {
                Label("No **favorites** set", systemImage: "heart.fill")
            } else {
                List {
                    ForEachStore(store.scope(state: \.movieStates,
                                             action: FavoritesAction.movie(index:action:)),
                                 content: MovieListRow.init(store:))
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
    }
}
