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
    func search(query: String) -> AnyPublisher<[Movie], MovieSearchError>
}

enum MovieSearchError: Error {
    case failed
    case invalidSearchTerm
}

struct AppMovieService: MovieService {
    
    let api: MovieApiService
    
    func search(query: String) -> AnyPublisher<[Movie], MovieSearchError> {
        guard !query.isEmpty else {
            return Fail(error: MovieSearchError.invalidSearchTerm).eraseToAnyPublisher()
        }
        return api.search(query: query)
            .receive(on: DispatchQueue.main)
            .map { $0.map(Movie.init) }
            .mapError { _ in .failed }
            .eraseToAnyPublisher()
    }
    
    
}
