import SwiftUI
import ComposableArchitecture
import Combine
import MovieApi

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
        movieService: AppMovieService(api: TheMovieDBApi()),
        favoriteService: InMemoryFavoriteService()
    )
}
