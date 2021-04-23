//
//  PageContainer.swift
//  MovieApi
//
//  Created by arconsis on 22.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation

extension MovieApi {
    struct PageContainer: Decodable {
        let page: Int
        let results: [Movie]
        let totalPages: Int
        let totalResults: Int
    }
}
