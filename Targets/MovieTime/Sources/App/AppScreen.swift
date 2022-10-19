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
    
    let store: StoreOf<MovieApp>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.isLoggedIn {
                TabView {
                    NavigationView {
                        HomeScreen(store: store.scope(state: \.home, action:  MovieApp.Action.home))
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    NavigationView {
                        SearchScreen(store: store.scope(state: \.search, action: MovieApp.Action.search))
                    }
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    NavigationView {
                        MyListsScreen(store: store.scope(state: \.lists, action: MovieApp.Action.lists))
                    }
                    .tabItem {
                        Label("My Lists", systemImage: "list.star")
                    }
                    NavigationView {
                        FavoritesScreen(store: store.scope(state: \.favorites, action: MovieApp.Action.favorites))
                    }
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                }
            } else {
                LoginScreen(store: store.scope(state: \.login, action: MovieApp.Action.login))
                    .transition(.move(edge: .bottom))
            }
        }
    }
}


