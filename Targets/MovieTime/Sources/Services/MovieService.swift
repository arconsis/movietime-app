//
//  MovieService.swift
//  MovieTime
//
//  Created by arconsis on 15.10.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import Combine
import MovieApi


protocol MovieService {
    func search(query: String, page: Int) -> AnyPublisher<[Movie], MovieServiceError>
    func movie(withId movieId: Int) -> AnyPublisher<Movie, MovieServiceError>
    func movies(type: MovieCollectionType, page: Int) -> AnyPublisher<[Movie], MovieServiceError>
}

public enum MovieCollectionType {
    case latest
    case nowPlaying
    case popular
    case topRated
    case upcoming
}

enum MovieServiceError: Error  {
    case failed
    case invalidSearchTerm
}

struct AppMovieService: MovieService {
    
    let api: MovieApiService
    
    func search(query: String, page: Int) -> AnyPublisher<[Movie], MovieServiceError> {
        guard !query.isEmpty else {
            return Fail(error: MovieServiceError.invalidSearchTerm).eraseToAnyPublisher()
        }
        return api.search(query: query, page: page)
            .receive(on: DispatchQueue.main)
            .map { $0.map(Movie.init) }
            .mapError { _ in .failed }
            .eraseToAnyPublisher()
    }
    
    func movie(withId movieId: Int) -> AnyPublisher<Movie, MovieServiceError> {
        api.detail(movieId:movieId)
            .receive(on: DispatchQueue.main)
            .map { Movie(movie: $0) }
            .mapError { _ in .failed }
            .eraseToAnyPublisher()
    }
    
    func movies(type: MovieCollectionType, page: Int) -> AnyPublisher<[Movie], MovieServiceError> {
        api.movies(type: type.apiType, page: page)
            .receive(on: DispatchQueue.main)
            .map { $0.map(Movie.init) }
            .mapError { _ in .failed }
            .eraseToAnyPublisher()
    }
}

extension MovieCollectionType {
    var apiType: MovieApi.MovieCollectionType {
        switch self {
        case .latest:
            return .latest
        case .nowPlaying:
            return .nowPlaying
        case .popular:
            return .popular
        case .topRated:
            return .topRated
        case .upcoming:
            return .upcoming
        }
    }
}
