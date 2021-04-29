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
