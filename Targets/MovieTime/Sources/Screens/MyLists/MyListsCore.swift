import ComposableArchitecture
import Foundation

struct MyMovieList: Identifiable, Equatable {
    let id: UUID
    let name: String
    var movies: [MyMovieList]?
}

struct MyLists: ReducerProtocol {
    struct State: Equatable {
        var lists: [MyMovieList] = []
    }

    enum Action {
        case addList
    }
    
    @Dependency(\.uuid) var uuid

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .addList:
            state.lists.append(
                MyMovieList(id: uuid(), name: "My List \(state.lists.count + 1)",
                            movies: [.init(id: uuid(), name:"Movie 1"), .init(id: uuid(), name:"Movie 2", movies: [.init(id: uuid(), name: "Foo"), .init(id: uuid(), name: "Bar")])])
            )
            print(state.lists)
            return .none
        }
    }
}
