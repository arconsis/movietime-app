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
    let id: Int
    let title: String
    let overview: String?
    let posterUrl: URL?
}

extension Movie {
    init(movie: MovieApi.Movie) {
        id = movie.id
        title = movie.title ?? "NA"
        overview = movie.overview
        posterUrl = movie.thumbnailUrl
    }
}

extension Movie {
    static let preview: [Movie] = [Movie(id: 0, title: "Movie", overview: "Some longer text about the movie and what it is about.", posterUrl: nil)]
}
