import Foundation
import ComposableArchitecture

enum Home {
    struct State: Equatable {
        var popular: MovieCollectionState = .init(type: .custom("Marvel"))
        var topRated: MovieCollectionState = .init(type: .custom("Star Wars"))
        var nowPlaying: MovieCollectionState = .init(type: .custom("Star Trek"))
    }

    enum Action {
        case popular(action:MovieCollectionAction)
        case topRated(action:MovieCollectionAction)
        case nowPlaying(action:MovieCollectionAction)
    }

    struct Environment { }

    static let reducer = Reducer<State, Action, AppEnvironment>.combine(
        movieCollectionReducer.pullback(
            state: \.popular,
            action: /Home.Action.popular,
            environment: { $0 }),
        movieCollectionReducer.pullback(
            state: \.topRated,
            action: /Home.Action.topRated,
            environment: { $0 }),
        movieCollectionReducer.pullback(
            state: \.nowPlaying,
            action: /Home.Action.nowPlaying,
            environment: { $0 })

    )
}
