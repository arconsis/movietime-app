import SwiftUI
import ComposableArchitecture

struct SearchScreen: View {

    let store: Store<Search.State, Search.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 0) {
                HStack {
                    Image(systemName:"magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Movie", text:viewStore.binding(
                        get: \.searchTerm,
                        send: Search.Action.searchFieldChanged))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                Divider()
                List {
                    ForEachStore(store.scope(state: \.movieStates, action: Search.Action.movie(movieId:action:)),
                                 content: MovieListRow.init(store:))
                    if viewStore.isLoadingMoreMovies {
                        HStack() {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    if viewStore.loadingMoreFailed {
                        Text("loading failed")
                            .foregroundColor(.red)
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    if viewStore.searchTerm.isEmpty {
                        viewStore.send(.searchFieldChanged("Marvel"))
                    }
                }
            }
        }
        .navigationTitle("Movie Time")
    }
}
