//
//  Movie.swift
//  MovieApi
//
//  Created by arconsis on 22.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation


public struct MovieDto: Codable {
    public init(id: Int, title: String? = nil, overview: String? = nil, originalTitle: String? = nil, posterPath: String? = nil, runtime: Int? = nil, releaseDate: String? = nil, backdropPath: String? = nil, genres: [GenreDto]? = nil, voteAverage: Double? = nil, status: String? = nil, revenue: Int? = nil, tagline: String? = nil) {
        self.id = id
        self.title = title
        self.overview = overview
        self.originalTitle = originalTitle
        self.posterPath = posterPath
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.genres = genres
        self.voteAverage = voteAverage
        self.status = status
        self.revenue = revenue
        self.tagline = tagline
    }
    
    public let id: Int
    public let title: String?
    public let overview: String?
    public let originalTitle: String?
    public let posterPath: String?
    public let runtime: Int?
    public let releaseDate: String?
    public let backdropPath: String?
    public let genres: [GenreDto]?
    public let voteAverage: Double?
    public let status: String?
    public let revenue: Int?
    public let tagline: String?
}

public struct GenreDto: Codable {
    public let id: Int
    public let name: String
}

public extension MovieDto {
    
    enum ImageSize: String {
        case original
        case thumbnail = "w200"
    }
    
    func createURL(path: String?, size: ImageSize = .thumbnail) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(path)")
    }
}
