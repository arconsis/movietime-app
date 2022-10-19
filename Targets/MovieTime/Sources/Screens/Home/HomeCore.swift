import ComposableArchitecture

struct Home: ReducerProtocol {
    struct State: Equatable {
        var popular: MovieCollection.State = .init(type: .popular)
        var topRated: MovieCollection.State = .init(type: .topRated)
        var nowPlaying: MovieCollection.State = .init(type: .nowPlaying)
        var search: MovieCollection.State = .init(type: .custom(title: "All about Matrix", query: "Matrix"))
    }

    enum Action {
        case popular(action:MovieCollection.Action)
        case topRated(action:MovieCollection.Action)
        case nowPlaying(action:MovieCollection.Action)
        case search(action:MovieCollection.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.popular, action: /Action.popular) {
            MovieCollection()
        }
        Scope(state: \.topRated, action: /Action.topRated) {
            MovieCollection()
        }
        Scope(state: \.nowPlaying, action: /Action.nowPlaying) {
            MovieCollection()
        }
        Scope(state: \.search, action: /Action.search) {
            MovieCollection()
        }
        
    }
}
