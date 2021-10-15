//
//  PageContainer.swift
//  MovieApi
//
//  Created by arconsis on 22.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation

struct PageContainerDto: Decodable {
    let page: Int
    let results: [MovieDto]
    let totalPages: Int
    let totalResults: Int
}
