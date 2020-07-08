//
//  NCCNavigationView.swift
//  NCCNavigation
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import SwiftUI

public struct NCCNavigationView<Content: View>: View, Identifiable {
    @ObservedObject private var navManager: NCCNavigationManager

    public let id = UUID()

    private var content: () -> Content

    public init(manager: NCCNavigationManager? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        let itemId = self.id.uuidString + "-NavigationViewContent"
        let item = NCCNavigationContentItem(id: itemId, view: AnyView(content())) {
            // This item should never be dismissed
            print("NCCNavigationContentItem: onDismiss: FATAL ERROR: NCCNavigationContentItem with id \(itemId) was dismissed!  (This should never happen!)")
            #if DEBUG
            fatalError()
            #else
            // Only warning for release -- might be better to force crash anyway
            #endif
        }

        let managerToUse = manager ?? NCCNavigationManager()
        managerToUse.reset(initialContentItem: item)
        self.navManager = managerToUse
    }

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.navManager.items) { item in
                        NCCNavigationHost(item: item)
                            .frame(width: geometry.size.width, height: nil)
                            .environmentObject(self.navManager)
                    }
                }
            }
            .content.offset(x: -geometry.size.width * CGFloat(self.navManager.index))
            .animation(.easeInOut)
            .frame(width: geometry.size.width,
                   height: nil,
                   alignment: .leading)
        }
    }
}
