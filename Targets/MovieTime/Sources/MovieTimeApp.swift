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

let movieService: MovieService = AppMovieService(api: TheMovieDBApi())

extension AppEnvironment {
    static let app: AppEnvironment = AppEnvironment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        search: movieService.search,
        load: { movieId in
            TheMovieDBApi().detail(movieId:movieId)
                .receive(on: DispatchQueue.main)
                .map { Movie(movie: $0) }
                .eraseToAnyPublisher()
        }
    )
}
