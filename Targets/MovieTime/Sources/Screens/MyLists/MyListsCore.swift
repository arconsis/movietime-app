import Foundation
import ComposableArchitecture

struct MyMovieList: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var movies: [MyMovieList]?
}

enum MyLists {
    struct State: Equatable {
        var lists: [MyMovieList] = []
    }

    enum Action {
        case addList
    }

    struct Environment {

    }

    static let reducer = Reducer<State, Action, Environment> { state, action, env in
        switch action {
        case .addList:
            state.lists.append(
                MyMovieList(name: "My List \(state.lists.count + 1)",
                            movies: [.init(name:"Movie 1"), .init(name:"Movie 2", movies: [.init(name: "Foo"), .init(name: "Bar")])])
                )
            print(state.lists)
            return .none
        default: return .none
        }
    }
}
