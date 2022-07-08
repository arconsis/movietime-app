import Foundation
import ComposableArchitecture
import AuthenticationServices
import KeychainSwift

enum Login {
    struct State: Equatable {
        var scopes: [ASAuthorization.Scope] = [.fullName, .email]
    }

    enum Action {
        case loggedIn
        case handleAppleSignIn(result: Result<ASAuthorization, Error>)
    }

    struct Environment {

    }

    static let reducer = Reducer<State, Action, Environment> { state, action, env in
        switch action {
        case .handleAppleSignIn(result: .success(let authorization)):
            
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                return .none
            }
            
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let token = appleIDCredential.identityToken
            
            
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            //                                    self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            //                                    self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
            
            
            
            return .none
        case .handleAppleSignIn(result: .failure(let error)):
            print(error)
            return .none
        default: return .none
        }
    }
}
