import SwiftUI
import ComposableArchitecture
import AuthenticationServices


struct LoginScreen: View {

    let store: Store<Login.State, Login.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 20) {
                Text(MovieTimeStrings.welcomeToMovieTime)
                    .font(.largeTitle)
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .foregroundColor(.init(MovieTimeAsset.loginIconColor.name))
                                
                Text("Sign in to continue")
                    .font(.subheadline)
                            SignInWithAppleButton(.continue) { request in
                                request.requestedScopes = viewStore.scopes
                            } onCompletion: {
                                viewStore.send(.handleAppleSignIn(result: $0))
                            }
                            .signInWithAppleButtonStyle(.whiteOutline)
                            .frame(height: 60)
                            .padding(.horizontal)
            }
        }
    }
}

struct LoginScreen_Preview: PreviewProvider {
    
    static var previews: some View {
        LoginScreen(
            store: Store(
                initialState: .init(),
                reducer: Login.reducer,
                environment: .init()))
    }
    
    
}
