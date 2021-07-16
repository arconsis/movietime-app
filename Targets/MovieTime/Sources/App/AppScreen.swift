//
//  AppScreen.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct AppScreen: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        TabView {
            NavigationView {
                MovieListScreen(store: store.scope(state: \.movieList, action: AppAction.movieList))
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            NavigationView {
                FavoritesScreen(store: store.scope(state: \.favorites, action: AppAction.favorites))
            }
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
        }
    }
}


