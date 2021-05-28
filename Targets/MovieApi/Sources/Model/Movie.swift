//
//  Movie.swift
//  MovieApi
//
//  Created by arconsis on 22.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation

public extension MovieApi {
    struct Movie: Codable {
        public let id: Int
        public let title: String?
        public let overview: String?
        public let originalTitle: String?
        public let posterPath: String?
    }
}

public extension MovieApi.Movie {
    
    var thumbnailUrl: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
        } else {
            return nil
        }
    }
    
    var posterUrl: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/original\(path)")
        } else {
            return nil
        }
    }
}
