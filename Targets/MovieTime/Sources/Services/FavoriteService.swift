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
    var publisher: AnyPublisher<Set<Movie>, Never> { get }
    func favorites() -> Set<Movie>
    func add(movie: Movie)
    func remove(movieId: Int)
    func isFavorite(movieId: Int) -> Bool
}

extension FavoriteService {
    func isFavorite(movieId: Int) -> AnyPublisher<Bool, Never> {
        publisher
            .map { favorites in
                favorites.contains { movie in
                    movie.id == movieId
                }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func toggle(movie: Movie) {
        let movieId = movie.id
        if isFavorite(movieId: movieId) {
            remove(movieId: movieId)
        } else {
            add(movie: movie)
        }
    }
}

class InMemoryFavoriteService: FavoriteService {
    
    @Published
    private var store: Set<Movie> = []
    
    var publisher: AnyPublisher<Set<Movie>, Never> {
        $store.eraseToAnyPublisher()
    }

    func favorites() -> Set<Movie> {
        return store
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

    let persistenceController = MoviePersistenceController()

    lazy var context: NSManagedObjectContext = {
        return persistenceController.container.newBackgroundContext()
    }()

    var publisher: AnyPublisher<Set<Movie>, Never> {
        persistenceController.publisher(for: MovieDB.self, in: context)
            .map { Set($0.map(Movie.init)) }
            .eraseToAnyPublisher()
    }

    func favorites() -> Set<Movie> {
        var movies: [MovieDB] = []
        context.performAndWait {
            movies = (try? self.context.fetch(MovieDB.fetchRequest())) ?? []
        }
        return Set(movies.map(Movie.init))
    }

    func isFavorite(movieId: Int) -> Bool {
        var isFavorite: Bool = false
        context.performAndWait {
            do {
                let movie = try MovieDB.fetch(movieId: movieId, context: self.context)
                isFavorite = movie != nil
            } catch {
                print("Error fetching context: \(error.localizedDescription)")
            }
        }
        return isFavorite
    }

    init() {}
    
    func add(movie: Movie) {
        context.perform {
            let movieDB = MovieDB(context: self.context)
            movieDB.map(movie: movie)
            self.persistenceController.save(context: self.context)
        }
    }
    
    func remove(movieId: Int) {
        context.perform {
            if let movie = try? MovieDB.fetch(movieId: movieId, context: self.context) {
                self.context.delete(movie)
                self.persistenceController.save(context: self.context)
            }
        }

    }
}

extension MovieDB {

    static func fetch(movieId: Int, context: NSManagedObjectContext) throws -> MovieDB? {
        return try context.fetch(fetchRequest(movieId: movieId)).first
    }

    static func fetchRequest(movieId: Int) -> NSFetchRequest<MovieDB> {
        let request = MovieDB.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", movieId)
        return request
    }

    func map(movie: Movie) {
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
