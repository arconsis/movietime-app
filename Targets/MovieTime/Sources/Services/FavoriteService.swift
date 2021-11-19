//
//  FavoriteService.swift
//  MovieTime
//
//  Created by arconsis on 05.11.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import Combine
import CoreData

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

class CoreDataFavoriteService: FavoriteService {
    var favorites: AnyPublisher<Set<Movie>, Never> {
        $store.eraseToAnyPublisher()
    }
    
    
    let persistenceController = MoviePersistenceController()
    
    lazy var context: NSManagedObjectContext = {
        return persistenceController.container.newBackgroundContext()
    }()
    
    func isFavorite(movieId: Int) -> Bool {
        var isFavorite: Bool = false
        context.performAndWait {
            do {
                let result = try self.context.fetch(self.fetchRequest(movieId: movieId))
                isFavorite = !result.isEmpty
            } catch {
                print("Error fetching context: \(error.localizedDescription)")
            }
        }
        return isFavorite
    }
    
    private func fetchRequest(movieId: Int) -> NSFetchRequest<MovieDB> {
        let request = MovieDB.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", movieId)
        return request
    }
    
    @Published
    private var store: Set<Movie> = []
    
    init() {
        updateStore()
    }
    
    func add(movie: Movie) {
        //        context.perform {
        _ = MovieDB(movie: movie, context: self.context)
        self.persistenceController.save(context: self.context)
        //        }
        updateStore()
    }
    
    func remove(movieId: Int) {
        //        context.perform {
        if let movie = try? self.context.fetch(self.fetchRequest(movieId: movieId)).first {
            self.context.delete(movie)
            self.persistenceController.save(context: self.context)
        }
        //        }
        updateStore()
    }
    
    private func updateStore() {
        //        context.perform {
        let allMovies: [Movie]? = try? self.context.fetch(MovieDB.fetchRequest()).map(Movie.init)
        self.store = Set(allMovies ?? [])
        
        //        }
    }
}

extension MovieDB {
    convenience init(movie: Movie, context:NSManagedObjectContext) {
        self.init(context: context)
        id = Int64(movie.id)
        title = movie.title
        overview = movie.overview
        posterUrl = movie.posterUrl
        posterThumbnail =  movie.posterThumbnail
        releaseDate = movie.releaseDate
        backdropUrl = movie.backdropUrl
        genres = nil
        voteAverage = movie.voteAverage
        status = movie.status
        revenue = Int64(movie.revenue)
        tagline = movie.tagline
        runtime = Int64(movie.runtime)
    }
}

extension Movie {
    init(movie: MovieDB) {
        id = Int(movie.id)
        title = movie.title ?? ""
        overview = movie.overview
        posterUrl = movie.posterUrl
        posterThumbnail =  movie.posterThumbnail
        releaseDate = movie.releaseDate
        backdropUrl = movie.backdropUrl
        genres = []
        voteAverage = movie.voteAverage
        status = movie.status ?? ""
        revenue = Int(movie.revenue)
        tagline = movie.tagline ?? ""
        runtime = Int(movie.runtime)
    }
}
