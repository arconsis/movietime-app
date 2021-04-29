import Foundation
import Combine

public struct MovieApi {}

public extension MovieApi {
    enum Error: Swift.Error {
        case search
    }
}

public extension MovieApi {
    
    static func search(query: String) -> AnyPublisher<[Movie], MovieApi.Error> {
        
        var components = URLComponents(string: "https://api.themoviedb.org/4/search/movie")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "API_KEY"),
            URLQueryItem(name: "query", value: query)
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let session = URLSession(configuration: .default)
        return session.dataTaskPublisher(for: components.url!)
            .map { $0.data }
            .decode(type: PageContainer.self, decoder: decoder)
            .map(\.results)
            .mapError { error in
                print(error)
                return MovieApi.Error.search
            }
            .eraseToAnyPublisher()
    }
}


