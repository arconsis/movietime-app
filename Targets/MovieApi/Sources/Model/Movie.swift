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
        public let runtime: Int?
        public let releaseDate: String?
        public let backdropPath: String?
        public let genres: [Genre]?
        public let voteAverage: Double?
        public let status: String?
        public let revenue: Int?
        public let tagline: String?
    }
    
    struct Genre: Codable {
        public let id: Int
        public let name: String
    }
}

public extension MovieApi.Movie {
    
    enum ImageSize: String {
        case original
        case thumbnail = "w200"
    }
    
    func createURL(path: String?, size: ImageSize = .thumbnail) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(path)")
    }
}
