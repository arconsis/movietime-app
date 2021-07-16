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
}

extension Movie {
    init(movie: MovieApi.Movie) {
        id = movie.id
        title = movie.title ?? "NA"
        overview = movie.overview
        posterUrl = movie.posterUrl
        posterThumbnail = movie.thumbnailUrl
        releaseDate = movie.releaseDate.flatMap { Movie.dateFormatter.date(from: $0) }
    }
}

extension Movie {
    static let preview: [Movie] = [Movie(id: 0, title: "Movie", overview: "Some longer text about the movie and what it is about.", posterThumbnail: nil, posterUrl: nil, releaseDate: Date())]
}
