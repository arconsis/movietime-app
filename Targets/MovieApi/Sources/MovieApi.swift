import Foundation
import Combine
import SwiftUI

public protocol MovieApiService {
    func search(query: String) -> AnyPublisher<[ListMovieDto], MovieApiError>
    func detail(movieId: Int) -> AnyPublisher<MovieDto, MovieApiError>
}

public enum MovieApiError: Swift.Error {
    case search
    case detail
}

public class MovieTimeBff: MovieApiService {
    
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        // "2019-03-06"
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(){
        session = URLSession(configuration: .default)
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom {
            let container = try $0.singleValueContainer()
            let string = try container.decode(String.self)
            guard let date = self.dateFormatter.date(from: string) else {
                throw DecodingError.dataCorruptedError(in: container,
                                                       debugDescription: "Invalid date: " + string)
            }
            return date
        }
        
    }
    
    public func search(query: String) -> AnyPublisher<[ListMovieDto], MovieApiError> {
    
        let url = Endpoints.search(query).url
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PageContainerDto<ListMovieDto>.self, decoder: decoder)
            .map(\.results)
            .mapError { error in
                print(error)
                return MovieApiError.detail
            }
            .eraseToAnyPublisher()
    }
    
    public func detail(movieId: Int) -> AnyPublisher<MovieDto, MovieApiError> {
        
        let url = Endpoints.detail(movieId).url
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
            #warning("get base url from env")
            var components = URLComponents(string: "http://localhost:8080/")!
            return components
        }
        
        var url: URL {
            var components = baseComponents
            switch self {
            case .search(let query):
                components.queryItems = [
                    URLQueryItem(name: "query", value: query)
                ]
                
                components.path.append("movies")
            case .detail(let movieId):
                components.path.append("movies/\(movieId)")
            }
            return components.url!
        }
    }
}


