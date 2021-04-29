import SwiftUI
import ComposableArchitecture
import MovieApi
import Combine

@main
struct MovieTime: App {
    
    var body: some Scene {
        WindowGroup {
            DemoScreen(
                store: Store<MovieListState, MovieListAction>(
                    initialState: MovieListState(),
                    reducer: movieListReducer,
                    environment: MovieListEnvironment(
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        search: search(query:)
                    ))
            )
        }
    }
    
    @State private var cancellables: Set<AnyCancellable> = []
 
    
    func search(query: String) -> Effect<[Movie], MovieApi.Error> {
        MovieApi.search(query: query)
            .receive(on: DispatchQueue.main)
            .map { $0.map { movie in Movie(title: movie.title ?? "", id: movie.id)} }
            .eraseToEffect()

            
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print("search error")
//                }
//            } receiveValue: { movies in
//                print(movies)
//            }
//            .
//            .store(in: &cancellables)
            
        
    }
}
