import Foundation
import ComposableArchitecture

enum Home {
    struct State: Equatable {
        var popular: MovieCollectionState = .init(type: .popular)
        var topRated: MovieCollectionState = .init(type: .topRated)
        var nowPlaying: MovieCollectionState = .init(type: .nowPlaying)
        var search: MovieCollectionState = .init(type: .custom(title: "All about Matrix", query: "Matrix"))
    }

    enum Action {
        case popular(action:MovieCollectionAction)
        case topRated(action:MovieCollectionAction)
        case nowPlaying(action:MovieCollectionAction)
        case search(action:MovieCollectionAction)
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
            environment: { $0 }),
        movieCollectionReducer.pullback(
            state: \.search,
            action: /Home.Action.search,
            environment: { $0 })

    )
}
