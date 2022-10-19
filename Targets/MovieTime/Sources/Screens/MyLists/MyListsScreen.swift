import SwiftUI
import ComposableArchitecture

struct MyListsScreen: View {

    let store: StoreOf<MyLists>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                List(viewStore.lists, children: \.movies) { row in
                    Text(row.name)
                }
            }
            .navigationBarItems(trailing: Button(action: {
                viewStore.send(.addList)
            }, label: {
                Image(systemName: "text.badge.plus")
            }))
        }
        .navigationTitle("My Lists")
    }
}

struct MovieDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        MyListsScreen(
            store: Store(initialState: MyLists.State(),
                         reducer: MyLists()))
    }
}
