import Foundation
import Combine
import SwiftUI

public protocol MovieApiService {
    func search(query: String) -> AnyPublisher<[MovieDto], MovieApiError>
    func detail(movieId: Int) -> AnyPublisher<MovieDto, MovieApiError>
}




public enum MovieApiError: Swift.Error {
    case search
    case detail
}


public struct TheMovieDBApi: MovieApiService {
    
    public init(){}
    
    public func search(query: String) -> AnyPublisher<[MovieDto], MovieApiError> {
        
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let url = Endpoints.search(query).url
        
        let session = URLSession(configuration: .default)
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PageContainerDto.self, decoder: decoder)
            .map(\.results)
            .mapError { error in
                print(error)
                return MovieApiError.detail
            }
            .eraseToAnyPublisher()
    }
    
    public func detail(movieId: Int) -> AnyPublisher<MovieDto, MovieApiError> {
        
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let url = Endpoints.detail(movieId).url
        print(url)
        let session = URLSession(configuration: .default)
        return session.dataTaskPublisher(for: url)
            .map {
                print(String(data: $0.data, encoding: .utf8)!)
                return $0.data
            }
            .decode(type: MovieDto.self, decoder: decoder)
            .mapError { error in
                print(error)
                return MovieApiError.search
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


