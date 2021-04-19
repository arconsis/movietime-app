import SwiftUI
import ComposableArchitecture
import MovieApi
import Combine

@main
struct MovieTime: App {
    
    var body: some Scene {
        WindowGroup {
            DemoScreen(
                store: Store<DemoState, DemoAction>(
                    initialState: DemoState(),
                    reducer: demoReducer,
                    environment: DemoEnvironment(
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        doSomething: {
                            return CurrentValueSubject("Something").eraseToEffect()
                        }
                    ))
            )
        }
    }
    
    func something() -> String {
        return "Something"
    }
}
