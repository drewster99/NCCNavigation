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
    @Environment(\.nccNavigationManager) private var navManager: NCCNavigationManager

    public let id: UUID
    let itemId: NCCNavigationContentItem.ID
    let label: () -> Label
    let destination: () -> Content

    let usingInternalState: Bool

    @Binding private var isPresentingExternal: Bool
    @State private var isPresentingInternal: Bool = false

    var isPresenting: Bool {
        get {
            usingInternalState ? isPresentingInternal : isPresentingExternal
        }
        nonmutating set {
            if usingInternalState {
                _isPresentingInternal.projectedValue.animation(.easeInOut).wrappedValue = newValue
            } else {
                _isPresentingExternal.projectedValue.animation(.easeInOut).wrappedValue = newValue
            }
        }
    }

    init(@ViewBuilder destination: @escaping () -> Content, @ViewBuilder label: @escaping () -> Label) {
        let id = UUID()

        self.id = id
        self.destination = destination
        self.label = label
        self.itemId = id.uuidString + "-Item"
        self._isPresentingExternal = .constant(false)
        self.usingInternalState = true
        debugOutput("New navlink (without binding) ---- id \(self.id.uuidString)")
    }

    init(label: Label, isPresenting: Binding<Bool>, @ViewBuilder destination: @escaping () -> Content) {
        let id = UUID()

        self.id = id
        self.destination = destination
        self.label = { label }
        self.itemId = id.uuidString + "-Item"
        self._isPresentingExternal = isPresenting
        self.usingInternalState = false
        debugOutput("New navlink (with binding) ---- id \(self.id.uuidString)")
    }


    init(label: Label, @ViewBuilder destination: @escaping () -> Content) {
        self.init(destination: destination, label: { label })
    }

    init(destination: Content, @ViewBuilder label: @escaping () -> Label) {
        self.init(destination: { destination }, label: label)
    }

    init(label: Label, destination: Content) {
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
            .onChange(of: self.isPresenting) { (newValue) in
                debugOutput("onChange \(self.id.uuidString): \(#function) new value: \(newValue), isPresenting = \(self.isPresenting)")
                if newValue {
                    let item = NCCNavigationContentItem(id: self.itemId, view: AnyView(self.destination())) {
                        // onDismiss
                        self.dismiss()
                    }
                    self.navManager.present(item)
                } else {
                    self.navManager.dismiss(self.itemId)
                }

        }.animation(.easeInOut)
    }
}


extension NCCNavLink where Label == Text {

    init(text: String, @ViewBuilder destination: @escaping () -> Content) {
        self.init(destination: destination, label: { Text(text) })
    }

    init(text: String, destination: Content) {
        self.init(text: text, destination: { destination })
    }
}