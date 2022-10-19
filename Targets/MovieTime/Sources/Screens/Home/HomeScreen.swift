import SwiftUI
import ComposableArchitecture

struct HomeScreen: View {

    let store: StoreOf<Home>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView() {
                VStack(alignment: .leading) {
                    MovieCollectionView(store: store.scope(state: \.popular, action: Home.Action.popular))
                    MovieCollectionView(store: store.scope(state: \.topRated, action: Home.Action.topRated))
                    MovieCollectionView(store: store.scope(state: \.nowPlaying, action: Home.Action.nowPlaying))
                    MovieCollectionView(store: store.scope(state: \.search, action: Home.Action.search))
                    Spacer()
                }
            }
        }
        .navigationTitle("Movie Time")
    }
}
