//
//  NCCNavigationManager.swift
//  NCCNavigation
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import SwiftUI

final public class NCCNavigationManager: ObservableObject, Identifiable {

    public let id = UUID()

    @State private var presentedItemIDs: Set<NCCNavigationContentItem.ID> = []
    @Published private(set) var items: [NCCNavigationContentItem] = []
    @Published var index: Int = 0
    @Published var canDismissCurrent = false

    static let defaultManager: NCCNavigationManager = {
        NCCNavigationManager()
    }()

    public init() {
        debugOutput("[for defaultManager]: \(id.uuidString)")
        // Needed for defaultManager
    }

    convenience init(_ initialContentItem: NCCNavigationContentItem) {
        self.init()
        self.reset(initialContentItem: initialContentItem)
    }

    func reset(initialContentItem item: NCCNavigationContentItem) {
        self.items = [item]
        index = 0
    }

    deinit {
        debugOutput("")
    }

    private func updateCanDismissCurrent() {
        let newValue = index > 0
        debugOutput("index=\(index), canDismissCurrent=\(canDismissCurrent), newValue=\(newValue)")
        if canDismissCurrent != newValue {
            canDismissCurrent = newValue
        }
    }

    func present(_ item: NCCNavigationContentItem) {
        debugOutput("manager \(id.uuidString): item.id = \(item.id)")

        let inHierarchy = presentedItemIDs.contains(item.id)

        guard !inHierarchy else {
            #if DEBUG
            debugOutput("item with id \(item.id) already presented -- ignored.")
            #endif
            return
        }

        presentedItemIDs.insert(item.id)
        items.append(item)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.index = self.items.count - 1
            self.updateCanDismissCurrent()
        }
    }

    func dismiss(_ itemId: NCCNavigationContentItem.ID) {
        debugOutput("manager \(id.uuidString): item.id = \(itemId)")

        guard !presentedItemIDs.contains(itemId) else {
            #if DEBUG
            debugOutput("item with id \(itemId) not in hierarchy -- ignored.")
            #endif
            return
        }

        presentedItemIDs.remove(itemId)

        guard let itemIndex = items.firstIndex(where: { (item) -> Bool in
            item.id == itemId
        }) else {
            #if DEBUG
            debugOutput("item with id \(itemId) not in stack -- ignored.")
            #endif
            return
        }

        guard itemIndex > 0 else {
            print("\(String(describing: type(of: self))): \(#function): WARNING: Attempting to dismiss item with index 0")
            return
        }

        guard index >= itemIndex else {
            #if DEBUG
            debugOutput("current index \(index) >= item index \(itemIndex) -- ignored.")
            #endif
            return
        }

        debugOutput("itemIndex is \(itemIndex), current index is \(self.index), item count is \(items.count)")

        // Show the right item
        index = itemIndex - 1

        items[itemIndex].onDismiss()

        // Nuke all the others
        items.removeLast(self.items.count - 1 - index)

        updateCanDismissCurrent()
    }

    /// Dismiss the top-most item only
    public func dismiss() {
        if let id = items.last?.id {
            dismiss(id)
        }
    }
}
