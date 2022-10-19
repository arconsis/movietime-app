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
    
    let store: StoreOf<Favorites>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
            if viewStore.movieStates.isEmpty {
                Label("No **favorites** set", systemImage: "heart.fill")
            } else {
                List {
                    ForEachStore(store.scope(state: \.movieStates,
                                             action: Favorites.Action.movie(index:action:)),
                                 content: MovieListRow.init(store:))
                }
                .listStyle(.plain)
            }
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
        .navigationTitle("Favorites")
    }
}
