import Foundation
import Combine
import SwiftUI

public protocol MovieApiService {
    func movies(type: MovieCollectionType, page: Int) -> AnyPublisher<[ListMovieDto], MovieApiError>
    func search(query: String, page: Int) -> AnyPublisher<[ListMovieDto], MovieApiError>
    func detail(movieId: Int) -> AnyPublisher<MovieDto, MovieApiError>
}

public enum MovieCollectionType: String {
    case latest
    case nowPlaying = "now-playing"
    case popular
    case topRated = "top-rated"
    case upcoming
}

public enum MovieApiError: Swift.Error {
    case search
    case detail
    case collection
}

public class MovieTimeBff: MovieApiService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(){
        session = URLSession(configuration: .default)
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    public func movies(type: MovieCollectionType, page: Int) -> AnyPublisher<[ListMovieDto], MovieApiError> {
        let request = Endpoints.collection(type: type, page: page).request
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: PageContainerDto<ListMovieDto>.self, decoder: decoder)
            .map(\.result)
            .mapError { error in
                print(error)
                return MovieApiError.collection
            }
            .eraseToAnyPublisher()
    }
    
    public func search(query: String, page: Int) -> AnyPublisher<[ListMovieDto], MovieApiError> {
    
        let request = Endpoints.search(query: query, page: page).request
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: PageContainerDto<ListMovieDto>.self, decoder: decoder)
            .map(\.result)
            .mapError { error in
                print(error)
                return MovieApiError.search
            }
            .eraseToAnyPublisher()
    }
    
    public func detail(movieId: Int) -> AnyPublisher<MovieDto, MovieApiError> {
        
        let request = Endpoints.detail(movieId).request
        return session.dataTaskPublisher(for: request)
            .map {
                print(String(data: $0.data, encoding: .utf8)!)
                return $0.data
            }
            .decode(type: MovieDto.self, decoder: decoder)
            .mapError { error in
                print(error)
                return MovieApiError.detail
            }
            .eraseToAnyPublisher()
    }
    
    enum Endpoints {
        case search(query: String, page: Int)
        case collection(type: MovieCollectionType, page: Int)
        case detail(Int)
        
        private var baseComponents: URLComponents {
            #warning("get base url from env")
            let components = URLComponents(string: "http://localhost:8080/")!
            return components
        }
        
        var url: URL {
            var components = baseComponents
            switch self {
            case .search(query: let query, page: let page):
                components.queryItems = [
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "page", value: "\(page)")
                ]
                
                components.path.append("movies")
            case .collection(type: let type, page: let page):
                components.queryItems = [
                    URLQueryItem(name: "collection", value: type.rawValue),
                    URLQueryItem(name: "page", value: "\(page)")
                ]
                components.path.append("movies")
            case .detail(let movieId):
                components.path.append("movies/\(movieId)")
            }
            return components.url!
        }
        
        var request: URLRequest {
            var request = URLRequest(url: self.url)
            let locale = Locale.current
            
            if let language = locale.languageCode {
                request.addValue(language, forHTTPHeaderField: "Accept-Language")
            }
            
            return request
        }
    }
}


