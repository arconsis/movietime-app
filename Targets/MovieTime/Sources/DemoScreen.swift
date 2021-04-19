//
//  DemoScreen.swift
//  MovieTime
//
//  Created by arconsis on 15.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct DemoScreen: View {
    
    let store: Store<DemoState, DemoAction>
    
    var body: some View {
        
        WithViewStore(store) { viewStore in
            VStack {
                TextField("input",
                          text: viewStore.binding(get: \.text,
                                                  send: DemoAction.didSomething))
                Text(viewStore.text)
                Button("Button") {
                    viewStore.send(.buttonTapped)
                }
            }
        }
    }
}

struct DemoScreen_Previews: PreviewProvider {
    static var previews: some View {
        DemoScreen(
            store: Store<DemoState, DemoAction>(
                initialState: DemoState(),
                reducer: demoReducer,
                environment: DemoEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    doSomething: {
                        return CurrentValueSubject("Something").eraseToEffect()
                    }
                ))
        )
    }
}

struct DemoState: Equatable {
    var text: String = "Hello, World!"
}

enum DemoAction: Equatable {
    case buttonTapped
    case didSomething(String)
}

struct DemoEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var doSomething: () -> Effect<String, Never>
}

let demoReducer = Reducer<DemoState, DemoAction, DemoEnvironment> { state, action, env in
    switch action {
    case .buttonTapped:
        return env.doSomething()
            .receive(on: env.mainQueue)
            .eraseToEffect()
            .map(DemoAction.didSomething)
    case .didSomething(let text):
        state.text = text
        return .none
    }

}.debug()
