import Foundation
import ComposableArchitecture

enum Search {
    struct State: Equatable {
        var searchTerm: String = ""
        var movieStates: IdentifiedArrayOf<MovieState> = []
    }

    enum Action {
        case showMovies(Result<[Movie], MovieSearchError>)
        case searchFieldChanged(String)
        case search(String)
        case movie(index: Int, action: MovieAction)
    }

    struct Environment { }

    static let reducer = Reducer<State, Action, AppEnvironment>.combine(
        movieReducer.forEach(
            state: \.movieStates,
            action: /Search.Action.movie(index:action:),
            environment: { $0 }),
    Reducer { state, action, env in
        switch action {
        case let .searchFieldChanged(term):
            struct SearchDebounceId: Hashable {}
            
            state.searchTerm = term
        
            return Effect(value: .search(term))
                .debounce(
                    id: SearchDebounceId(),
                    for: 0.5,
                    scheduler: env.mainQueue)
        case let .search(term):
            guard !term.isEmpty else {
                return Effect(value: .showMovies(.success([])))
            }
            return env.movieService.search(query: term)
                .receive(on: env.mainQueue)
                .catchToEffect()
                .map(Search.Action.showMovies)
        case let .showMovies(.success(movies)):
            state.movieStates = IdentifiedArrayOf<MovieState>(uniqueElements: movies.map { MovieState(movie: $0) })
            return .none
        case .showMovies(.failure):
            state.movieStates = []
            return .none
        default: return .none
        }

    })
}
