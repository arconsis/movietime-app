//
//  PageContainer.swift
//  MovieApi
//
//  Created by arconsis on 22.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import Foundation

struct PageContainerDto<Entry: Decodable>: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let result: [Entry]
}
