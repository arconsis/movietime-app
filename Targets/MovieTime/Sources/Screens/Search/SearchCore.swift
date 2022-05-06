import Foundation
import ComposableArchitecture

enum Search {
    struct State: Equatable {
        var searchTerm = ""
        var currentPage = 1
        var lastPageReached = false
        var isLoadingMoreMovies = false
        var loadingMoreFailed = false
        var movieStates: IdentifiedArrayOf<MovieState> = []
    }

    enum Action {
        case showMovies(Result<[Movie], MovieServiceError>)
        case appendMovies(Result<[Movie], MovieServiceError>)
        case searchFieldChanged(String)
        case search(String)
        case movie(movieId: Int, action: MovieAction)
        case loadMore
    }

    struct Environment { }

    static let reducer = Reducer<State, Action, AppEnvironment>.combine(
        movieReducer.forEach(
            state: \.movieStates,
            action: /Search.Action.movie(movieId:action:),
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
            state.currentPage = 1
            state.lastPageReached = false
            state.loadingMoreFailed = false
            guard !term.isEmpty else {
                return Effect(value: .showMovies(.success([])))
            }
            return env.movieService.search(query: term, page: state.currentPage)
                .receive(on: env.mainQueue)
                .catchToEffect()
                .map(Search.Action.showMovies)
        case .loadMore:
            guard !state.lastPageReached, !state.isLoadingMoreMovies else {
                return .none
            }
            state.currentPage += 1
            state.isLoadingMoreMovies = true
            state.loadingMoreFailed = false
            return env.movieService.search(query: state.searchTerm, page: state.currentPage)
                .receive(on: env.mainQueue)
                .catchToEffect()
                .map(Search.Action.appendMovies)
            
        case let .showMovies(.success(movies)):
            state.movieStates = IdentifiedArrayOf<MovieState>(uniqueElements: movies.map { MovieState(movie: $0) })
            return .none
        case .showMovies(.failure):
            state.movieStates = []
            return .none
            
        case let .appendMovies(.success(movies)):
            guard !movies.isEmpty else {
                state.lastPageReached = true
                return .none
            }
            state.isLoadingMoreMovies = false
            movies.forEach { movie in
                state.movieStates.append(MovieState(movie: movie))
            }
            return .none
        case .appendMovies(.failure):
            state.isLoadingMoreMovies = false
            state.loadingMoreFailed = true
            return .none
        case .movie(movieId: let movieId, action: .viewAppeared):
            let movieIdToTriggerLoading = state.movieStates[max(0,state.movieStates.count - 3)].id
            
            if movieIdToTriggerLoading == movieId {
                return Effect(value: .loadMore)
            } else {
                return .none
            }
        default: return .none
        }

    })
}
