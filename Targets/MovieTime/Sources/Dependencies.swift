//
//  Dependencies.swift
//  MovieTime
//
//  Created by Jonas Stubenrauch on 18.10.22.
//  Copyright © 2022 arconsis. All rights reserved.
//

import ComposableArchitecture
import MovieApi

extension DependencyValues {
    var movieService: MovieService {
        get { self[MovieServiceKey.self] }
        set { self[MovieServiceKey.self] = newValue }
    }
    
    private enum MovieServiceKey: DependencyKey {
        typealias Value = MovieService
        
        static let liveValue: MovieService = AppMovieService(api:  MovieTimeBff())
    }
    
    var favoriteService: FavoriteService {
        get { self[FavoriteServiceKey.self] }
        set { self[FavoriteServiceKey.self] = newValue }
    }
    
    private enum FavoriteServiceKey: DependencyKey {
        typealias Value = FavoriteService
        
        static let liveValue: FavoriteService = CoreDataFavoriteService()
        static var previewValue: FavoriteService = InMemoryFavoriteService()
    }
}
