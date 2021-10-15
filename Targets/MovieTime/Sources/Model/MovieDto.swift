//
//  Movie.swift
//  MovieTime
//
//  Created by arconsis on 22.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation
import SwiftUI
import MovieApi

struct Movie: Equatable, Identifiable {
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // "2019-03-06"
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let id: Int
    let title: String
    let overview: String?
    let posterThumbnail: URL?
    let posterUrl: URL?
    var isFavorite: Bool = false
    let releaseDate: Date?
    let backdropUrl: URL?
    let genres: [String]
    let voteAverage: Double
    let status: String
    let revenue: Int
    let tagline: String
    let runtime: Int
}

extension Movie {
    init(movie: MovieApi.MovieDto) {
        id = movie.id
        title = movie.title ?? "NA"
        overview = movie.overview
        posterUrl = movie.createURL(path: movie.posterPath, size: .original)
        posterThumbnail =  movie.createURL(path: movie.posterPath)
        releaseDate = movie.releaseDate.flatMap { Movie.dateFormatter.date(from: $0) }
        backdropUrl = movie.createURL(path: movie.backdropPath, size: .original)
        genres = movie.genres?.map(\.name) ?? []
        voteAverage = movie.voteAverage ?? 0.0
        status = movie.status ?? "unknown"
        revenue = movie.revenue ?? 0
        tagline = movie.tagline ?? ""
        runtime = movie.runtime ?? 0
    }
}

extension Movie {
    static let preview: [Movie] = [Movie(
        id: 0,
        title: "Movie",
        overview: "Some longer text about the movie and what it is about.",
        posterThumbnail: URL(string: "https://image.tmdb.org/t/p/original/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg"),
        posterUrl: URL(string: "https://image.tmdb.org/t/p/original/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg"),
        releaseDate: Date(),
        backdropUrl: URL(string: "https://image.tmdb.org/t/p/original/w2PMyoyLU22YvrGK3smVM9fW1jj.jpg"),
        genres:["Action", "Sci-Fi"],
        voteAverage:5.0,
        status:"Released",
        revenue:1000000,
        tagline:"some tagline",
        runtime:90)]
}
