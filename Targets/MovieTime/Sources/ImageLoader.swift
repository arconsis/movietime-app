//
//  ImageLoader.swift
//  MovieTime
//
//  Created by arconsis on 20.05.21.
//  Copyright © 2021 arconsis. All rights reserved.
//  Inspired by: https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/
//

import Foundation
import Combine
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

class ImageLoader: ObservableObject {

    @Published
    var image: UIImage?
    private let url: URL
    
    private var cancellable: AnyCancellable?
    
    private var imageCache: ImageCache?
    
    private var isLoading = false
    private static let queue = DispatchQueue(label: "image-loading")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.imageCache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        
        guard !isLoading else { return }
        
        if let image = imageCache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.queue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.isLoading = true },
                receiveOutput: { [weak self] in self?.cache($0) },
                receiveCompletion: { [weak self] _ in self?.isLoading = false },
                receiveCancel: { [weak self] in self?.isLoading = false })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func cache(_ image: UIImage?) {
        imageCache?[url] = image
    }
}

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
                    .aspectRatio(contentMode: .fit)
            } else {
                Rectangle()
            }
        }.onAppear {
            
            loader.load()
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
