import SwiftUI
import ComposableArchitecture

struct HomeScreen: View {

    let store: Store<Home.State, Home.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView() {
                VStack(alignment: .leading) {
                    MovieCollection(store: store.scope(state: \.popular, action: Home.Action.popular))
                    MovieCollection(store: store.scope(state: \.topRated, action: Home.Action.topRated))
                    MovieCollection(store: store.scope(state: \.nowPlaying, action: Home.Action.nowPlaying))
                    MovieCollection(store: store.scope(state: \.search, action: Home.Action.search))
                    Spacer()
                }
            }
        }
        .navigationTitle("Movie Time")
    }
}
