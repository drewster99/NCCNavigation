//
//  NCCNavLink.swift
//  NCCNavigation
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import SwiftUI

public struct NCCNavLink<Content: View, Label: View>: View, Identifiable {
    @EnvironmentObject private var navManager: NCCNavigationManager

    public let id: UUID

    let itemId: NCCNavigationContentItem.ID
    let label: () -> Label
    let destination: () -> Content

    let usingInternalState: Bool

    @Binding private var isPresentingExternal: Bool {
        willSet {
            print("isPresentingExternal... new=\(newValue), old=\(isPresentingExternal)")
            self.isPresenting = newValue
        }
    }
    @State private var isPresentingInternal: Bool = false
    @State private var isPresenting: Bool = false {
        willSet {
            print("... willSet old=\(isPresenting), newValue=\(newValue)")
        }
        didSet {
            print("... didSet isPresenting=\(isPresenting), old=\(oldValue)")
            guard isPresenting != oldValue else { print("... isPresenting unchanged -- abort"); return }
            
            if isPresenting {
                let item = NCCNavigationContentItem(id: self.itemId, view: AnyView(self.destination())) {
                    // onDismiss
                    self.dismiss()
                }
                self.navManager.present(item)
            } else {
                self.navManager.dismiss(self.itemId)
            }

        }
    }

    var isPresenting2: Bool {
        get {
            usingInternalState ? isPresentingInternal : isPresentingExternal
        }
        nonmutating set {
            let old = isPresenting
            if usingInternalState {
                _isPresentingInternal.projectedValue.animation(.easeInOut).wrappedValue = newValue
            } else {
                _isPresentingExternal.projectedValue.animation(.easeInOut).wrappedValue = newValue
            }

            debugOutput("fake isPresenting:didSet: old=\(old), new=\(newValue), isPresenting after update=\(isPresenting)")
        }
    }

    public init(@ViewBuilder destination: @escaping () -> Content, @ViewBuilder label: @escaping () -> Label) {
        let id = UUID()

        self.id = id
        self.destination = destination
        self.label = label
        self.itemId = id.uuidString + "-Item"
        self._isPresentingExternal = .constant(false)
        self.usingInternalState = true
        debugOutput("New navlink (without binding) ---- id \(self.id.uuidString)")
    }

    public init(label: Label, isPresenting: Binding<Bool>, @ViewBuilder destination: @escaping () -> Content) {
        let id = UUID()

        self.id = id
        self.destination = destination
        self.label = { label }
        self.itemId = id.uuidString + "-Item"
        self._isPresentingExternal = isPresenting
        self.usingInternalState = false
        debugOutput("New navlink (with binding) ---- id \(self.id.uuidString)")
    }


    public init(label: Label, @ViewBuilder destination: @escaping () -> Content) {
        self.init(destination: destination, label: { label })
    }

    public init(destination: Content, @ViewBuilder label: @escaping () -> Label) {
        self.init(destination: { destination }, label: label)
    }

    public init(label: Label, destination: Content) {
        self.init(destination: { destination }, label: { label })
    }

    func present() {
        debugOutput("NCCNavLink \(id.uuidString): \(#function) [old isPresenting = \(self.isPresenting)]")
        self.isPresenting = true
    }

    func dismiss() {
        debugOutput("NCCNavLink \(id.uuidString): \(#function) [old isPresenting = \(self.isPresenting)]")
        self.isPresenting = false
    }

    public var body: some View {
        Button(action: {
            self.present()
        }, label: label)
//            .onChange(of: self.isPresenting) { (newValue) in
//                debugOutput("onChange \(self.id.uuidString): \(#function) new value: \(newValue), isPresenting = \(self.isPresenting)")
//                if newValue {
//                    let item = NCCNavigationContentItem(id: self.itemId, view: AnyView(self.destination())) {
//                        // onDismiss
//                        self.dismiss()
//                    }
//                    self.navManager.present(item)
//                } else {
//                    self.navManager.dismiss(self.itemId)
//                }
//
//        }
        .animation(.easeInOut)
    }
}


public extension NCCNavLink where Label == Text {

    init(text: String, @ViewBuilder destination: @escaping () -> Content) {
        self.init(destination: destination, label: { Text(text) })
    }

    init(text: String, destination: Content) {
        self.init(text: text, destination: { destination })
    }
}
