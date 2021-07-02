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
            MovieListScreen(store: store.scope(state: \.movieList, action: AppAction.movieList))
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            FavoritesScreen(store: store.scope(state: \.favorites, action: AppAction.favorites))
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

//struct AppView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppScreen(store: Store(
//            initialState: AppState(),
//            reducer: appReducer,
//            environment: .init(mainQueue: .main, search: { _ in return []})))
//    }
//}
