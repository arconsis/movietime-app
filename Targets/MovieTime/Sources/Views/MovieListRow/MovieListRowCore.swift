//
//  MovieListCore.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

enum MovieAction: Equatable {
    case toggleFavorite
}

struct MovieEnvironment {}

let movieReducer = Reducer<Movie, MovieAction, MovieEnvironment> { movie, action, _ in
    switch action {
    case .toggleFavorite:
        movie.isFavorite.toggle()
        return .none
    }
}
