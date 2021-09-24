//
//  ImageCache.swift
//  MovieTime
//
//  Created by arconsis on 20.05.21.
//  Copyright © 2021 arconsis. All rights reserved.
//  Inspired by: https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
//

import SwiftUI

protocol ImageCache {
    subscript(_ key: URL) -> UIImage? { get set }
}

struct InMemoryCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            if let image = newValue {
                cache.setObject(image, forKey: key as NSURL)
            } else {
                cache.removeObject(forKey: key as NSURL)
            }
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static var defaultValue: ImageCache = InMemoryCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
