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
        WithViewStore(store) { viewStore in
            if viewStore.isLoggedIn {
                TabView {
                    NavigationView {
                        HomeScreen(store: store.scope(state: \.home, action: AppAction.home))
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    NavigationView {
                        SearchScreen(store: store.scope(state: \.search, action: AppAction.search))
                    }
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    NavigationView {
                        MyListsScreen(store: store.scope(state: \.lists, action: AppAction.lists))
                    }
                    .tabItem {
                        Label("My Lists", systemImage: "list.star")
                    }
                    NavigationView {
                        FavoritesScreen(store: store.scope(state: \.favorites, action: AppAction.favorites))
                    }
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                }
            } else {
                LoginScreen(store: store.scope(state: \.login, action: AppAction.login))
                    .transition(.move(edge: .bottom))
            }
        }
    }
}


