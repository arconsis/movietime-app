import SwiftUI
import ComposableArchitecture
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
        search: movieService.search,
        load: movieService.movie
    )
}
