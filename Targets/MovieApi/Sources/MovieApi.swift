import Foundation
import Combine

public struct MovieApi {}

public extension MovieApi {
    enum Error: Swift.Error {
        case search
    }
}

public extension MovieApi {
    
    static func search(query: String) async throws -> [Movie] {
        let url = createURL(forQuery: query)
        
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
        
        let url = createURL(forQuery: query)
        
        let session = URLSession(configuration: .default)
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PageContainer.self, decoder: decoder)
            .map(\.results)
            .mapError { error in
                print(error)
                return MovieApi.Error.search
            }
            .eraseToAnyPublisher()
    }
    
    private static func createURL(forQuery query: String) -> URL {
        var components = URLComponents(string: "https://api.themoviedb.org/4/search/movie")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "query", value: query)
        ]
        return components.url!
    }
}


