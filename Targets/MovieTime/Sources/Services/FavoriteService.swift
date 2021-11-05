//
//  FavoriteService.swift
//  MovieTime
//
//  Created by arconsis on 05.11.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import Combine

protocol FavoriteService {
    var favorites: AnyPublisher<Set<Movie>, Never> { get }

    func add(movie: Movie)
    func remove(movieId: Int)
    func isFavorite(movieId: Int) -> Bool
}

extension FavoriteService {
    func isFavorite(movieId: Int) -> AnyPublisher<Bool, Never> {
        favorites
            .map { favorites in
                favorites.contains { movie in
                    movie.id == movieId
                }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func toggle(movie: Movie) -> Bool {
        let movieId = movie.id
        if isFavorite(movieId: movieId) {
            remove(movieId: movieId)
        } else {
            add(movie: movie)
        }
        
        return isFavorite(movieId: movieId)
    }
}

class InMemoryFavoriteService: FavoriteService {
    
    @Published
    private var store: Set<Movie> = []
    
    var favorites: AnyPublisher<Set<Movie>, Never> {
        $store.eraseToAnyPublisher()
    }
    
    func add(movie: Movie) {
        store.insert(movie)
    }
    
    func remove(movieId: Int) {
        if let index = store.firstIndex(where: { $0.id == movieId }) {
            store.remove(at: index)
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        store.contains { $0.id == movieId }
    }
    
    
}
