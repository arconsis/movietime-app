//
//  FavoritesCore.swift
//  MovieTime
//
//  Created by arconsis on 02.07.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct FavoritesState: Equatable {
    
}

enum FavoritesAction {
    
}

struct FavoritesEnvironment {
    
}

let favoritesReducer = Reducer<FavoritesState, FavoritesAction, FavoritesEnvironment> { _, _ ,_ in
    return .none
}
