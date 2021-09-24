import Foundation
import Combine
import SwiftUI

public struct MovieApi {}

public extension MovieApi {
    enum Error: Swift.Error {
        case search
        case detail
    }
}

public extension MovieApi {
    
    static func search(query: String) async throws -> [Movie] {
        let url = Endpoints.search(query).url
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let session = URLSession(configuration: .default)
        
        do {
            let (data, _) = try await session.data(from: url)
            return try decoder.decode(PageContainer.self, from: data).results
                
        } catch {
            throw MovieApi.Error.search
        }
    }
    
    static func search(query: String) -> AnyPublisher<[Movie], MovieApi.Error> {
        
    
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let url = Endpoints.search(query).url
        
        let session = URLSession(configuration: .default)
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PageContainer.self, decoder: decoder)
            .map(\.results)
            .mapError { error in
                print(error)
                return MovieApi.Error.detail
            }
            .eraseToAnyPublisher()
    }
    
    static func detail(movieId: Int) -> AnyPublisher<Movie, MovieApi.Error> {
        
    
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .iso8601
        
        let url = Endpoints.detail(movieId).url
        print(url)
        let session = URLSession(configuration: .default)
        return session.dataTaskPublisher(for: url)
            .map {
                print(String(data: $0.data, encoding: .utf8)!)
                return $0.data
            }
            .decode(type: Movie.self, decoder: decoder)
            .mapError { error in
                print(error)
                return MovieApi.Error.search
            }
            .eraseToAnyPublisher()
    }

    enum Endpoints {
        case search(String)
        case detail(Int)
        
        private var baseComponents: URLComponents {
            var components = URLComponents(string: "https://api.themoviedb.org/3/")!
            components.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
            ]
            return components
        }

        var url: URL {
            var components = baseComponents
            switch self {
            case .search(let query):
                components.queryItems?.append(URLQueryItem(name: "query", value: query))
                components.path.append("search/movie")
            case .detail(let movieId):
                components.path.append("movie/\(movieId)")
            }
            return components.url!
        }
    }
}


