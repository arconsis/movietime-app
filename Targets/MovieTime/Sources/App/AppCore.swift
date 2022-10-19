//
//  AppCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import ComposableArchitecture

struct MovieApp: ReducerProtocol {
    
    struct State: Equatable {
        var isLoggedIn = false
        var home = Home.State()
        var search = Search.State()
        var favorites = Favorites.State()
        var lists = MyLists.State()
        var login = Login.State()
    }
    
    enum Action {
        case home(action: Home.Action)
        case search(action: Search.Action)
        case favorites(action: Favorites.Action)
        case lists(action: MyLists.Action)
        case login(action: Login.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
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
        
        Scope(state: \.home, action: /Action.home) {
            Home()
        }
        
        Scope(state: \.search, action: /Action.search(action:)) {
            Search()
        }
        
        Scope(state: \.lists, action: /Action.lists) {
            MyLists()
        }
        
        Scope(state: \.favorites, action: /Action.favorites(action:)) {
            Favorites()
        }
        
        Scope(state: \.login, action: /Action.login(action:)) {
            Login()
        }
    }
}
