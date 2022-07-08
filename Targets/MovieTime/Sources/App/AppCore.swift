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
    var isLoggedIn = false
    var home: Home.State = .init()
    var search: Search.State = .init()
    var favorites: FavoritesState = .init()
    var lists: MyLists.State = .init()
    var login: Login.State = .init()
}

enum AppAction {
    case home(action: Home.Action)
    case search(action: Search.Action)
    case favorites(action: FavoritesAction)
    case lists(action: MyLists.Action)
    case login(action: Login.Action)
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
    
    Login.reducer.pullback(
        state: \.login,
        action: /AppAction.login,
        environment: { _ in .init() }),
    
    .init { state, action ,_ in
        switch action {
        case .lists(action: .addList):
            print("Add list in App reducer")
            return .none
        case .login(action: .loggedIn):
            state.isLoggedIn = true
            return .none
        default:
            return .none
        }
    }
)
