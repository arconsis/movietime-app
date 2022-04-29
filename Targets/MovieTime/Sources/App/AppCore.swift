//
//  AppCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import Combine
import ComposableArchitecture

struct AppState: Equatable {
    var home: Home.State = Home.State()
    var search: Search.State = Search.State()
    var favorites: FavoritesState = FavoritesState()
    var lists: MyLists.State = .init()
}

enum AppAction {
    case home(action: Home.Action)
    case search(action: Search.Action)
    case favorites(action: FavoritesAction)
    case lists(action: MyLists.Action)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var movieService: MovieService
    var favoriteService: FavoriteService
}


let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Home.reducer.pullback(
        state: \.home,
        action: /AppAction.home,
        environment: { $0 }),
    
    Search.reducer.pullback(
        state: \.search,
        action: /AppAction.search,
        environment: { $0 }),
    
    MyLists.reducer.pullback(
        state: \.lists,
        action: /AppAction.lists,
        environment: { _ in .init() }),
    
    favoritesReducer.pullback(
        state: \.favorites,
        action: /AppAction.favorites,
        environment: { $0}),
    
    .init { state, action ,_ in
        switch action {
        case .lists(action: .addList):
            print("Add list in App reducer")
            return .none
        default:
            return .none
        }
    }
)
