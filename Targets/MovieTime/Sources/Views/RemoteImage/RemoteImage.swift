//
//  ImageLoader.swift
//  MovieTime
//
//  Created by arconsis on 20.05.21.
//  Copyright © 2021 arconsis. All rights reserved.
//  Inspired by: https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
//

import SwiftUI

struct RemoteImage: View {
    
    @StateObject
    var loader: ImageLoader
    
    init(url: URL) {
        let loader = ImageLoader(url: url,
                                 cache: Environment(\.imageCache).wrappedValue)
        _loader = StateObject(wrappedValue:loader)
    }
    
    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Rectangle()
            }
        }.onAppear {
            
            loader.load()
        }
    }
}
