import SwiftUI
import ComposableArchitecture
import MovieApi
import Combine

@main
struct MovieTime: App {

    var body: some Scene {
        WindowGroup {
            AppScreen(store: .init(
                initialState: AppState(),
                reducer: appReducer,
                environment: .app
            ))
        }
    }
}

extension AppEnvironment {
    static let app: AppEnvironment = AppEnvironment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        search: { query in
            MovieApi.search(query: query)
                .receive(on: DispatchQueue.main)
                .map { $0.map(Movie.init) }
                .eraseToAnyPublisher()
        },
        load: { movieId in
            MovieApi.detail(movieId:movieId)
                .receive(on: DispatchQueue.main)
                .map { Movie(movie: $0) }
                .eraseToAnyPublisher()
        }
    )
}
