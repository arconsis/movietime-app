import ComposableArchitecture
import AuthenticationServices

struct Login: ReducerProtocol {
    struct State: Equatable {
        var scopes: [ASAuthorization.Scope] = [.fullName, .email]
    }

    enum Action {
        case loggedIn
        case handleAppleSignIn(result: Result<ASAuthorization, Error>)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .handleAppleSignIn(result: .success(let authorization)):
            
//            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//                return .none
//            }
            
            
            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            let token = appleIDCredential.identityToken
            
            
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            //                                    self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            //                                    self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
            
            
            return Effect(value: .loggedIn)
        case .handleAppleSignIn(result: .failure(let error)):
            print(error)
            return Effect(value: .loggedIn)
        default: return .none
        }
    }
}
