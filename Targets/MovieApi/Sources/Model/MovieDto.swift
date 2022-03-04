//
//  Movie.swift
//  MovieApi
//
//  Created by arconsis on 22.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation

public struct ListMovieDto: Codable {
    public let id: Int
    public let title: String?
    public let originalTitle: String?
    public let description: String?
    public let releaseDate: Date?
    public let poster: ImageDto?
}

public struct MovieDto: Codable {
    public let id: Int
    public let title: String?
    public let originalTitle: String?
    public let description: String?
    public let releaseDate: Date?
    public let runtime: Int?
    public let tagline: String?
    public let voteAverage: Double?
    public let poster: ImageDto?
    public let backdrop: ImageDto?
    public let genres: [GenreDto]?
}

public struct ImageDto: Codable {
    public let thumbnail: URL
    public let original: URL
}

public struct GenreDto: Codable {
    public let id: Int
    public let name: String
}
