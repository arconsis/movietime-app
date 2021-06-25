import SwiftUI
import ComposableArchitecture
import MovieApi
import Combine

@main
struct MovieTime: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MovieListScreen(
                    store: Store<MovieListState, MovieListAction>(
                        initialState: MovieListState(),
                        reducer: movieListReducer,
                        environment: MovieListEnvironment(
                            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                            search: search(query:)
                        ))
                ).tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                Text("test")
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
            }
        }
    }
    
    @State private var cancellables: Set<AnyCancellable> = []
 
    
    func search(query: String) -> AnyPublisher<[Movie], MovieApi.Error> {
        return Future { resolver in
            async {
                do {
                    let movies = try await MovieApi.search(query: query)
                    resolver(.success(movies.map(Movie.init)))
                } catch {
                    resolver(.failure(error as! MovieApi.Error))
                }
            }
        }.eraseToAnyPublisher()



//        MovieApi.search(query: query)
//            .receive(on: DispatchQueue.main)
//            .map { $0.map(Movie.init) }
//            .eraseToAnyPublisher()
    }
}
