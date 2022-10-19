import SwiftUI
import ComposableArchitecture

@main
struct MovieTime: App {

    var body: some Scene {
        WindowGroup {
            AppScreen(store: Store(
                initialState: MovieApp.State(),
                reducer: MovieApp()
            ))
        }
    }
}
