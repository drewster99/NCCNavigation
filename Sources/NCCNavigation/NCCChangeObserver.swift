//
//  NCCChangeObserver.swift
//  NCCNavigationView
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct NCCChangeObserver<Base: View, Value: Equatable>: View {
    let base: Base
    let value: Value
    let action: (Value)->Void

    @State var model = Model()

    init(base: Base, value: Value, action: @escaping (Value) -> Void) {
        self.base = base
        self.value = value
        self.action = action
    }

    var body: some View {
        if model.update(value: value) {
            DispatchQueue.main.async { self.action(self.value) }
        }
        return base
    }

    class Model {
        private var savedValue: Value?

        init() {
            print("NCCChangeObserver.Model init...")
        }
        deinit {
            print("NCCChangeObserver.Model deinit...")
        }
        func update(value: Value) -> Bool {
            guard value != savedValue else { return false }
            savedValue = value
            return true
        }
    }
}

extension View {
    /// Adds a modifier for this view that fires an action when a specific value changes.
    ///
    /// You can use `onChange` to trigger a side effect as the result of a value changing, such as an Environment key or a Binding.
    ///
    /// `onChange` is called on the main thread. Avoid performing long-running tasks on the main thread. If you need to perform a long-running task in response to value changing, you should dispatch to a background queue.
    ///
    /// The new value is passed into the closure. The previous value may be captured by the closure to compare it to the new value. For example, in the following code example, PlayerView passes both the old and new values to the model.
    ///
    /// ```
    /// struct PlayerView : View {
    ///   var episode: Episode
    ///   @State private var playState: PlayState
    ///
    ///   var body: some View {
    ///     VStack {
    ///       Text(episode.title)
    ///       Text(episode.showTitle)
    ///       PlayButton(playState: $playState)
    ///     }
    ///   }
    ///   .onChange(of: playState) { [playState] newState in
    ///     model.playStateDidChange(from: playState, to: newState)
    ///   }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - action: A closure to run when the value changes.
    ///   - newValue: The new value that failed the comparison check.
    /// - Returns: A modified version of this view
    func onChange<Value: Equatable>(of value: Value, perform action: @escaping (_ newValue: Value)->Void) -> NCCChangeObserver<Self, Value> {
        print("*** instantiating new change observer")
        return NCCChangeObserver(base: self, value: value, action: action)
    }
}
