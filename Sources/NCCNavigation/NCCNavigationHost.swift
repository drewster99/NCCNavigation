//
//  NCCNavigationHost.swift
//  NCCNavigation
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import SwiftUI

struct NCCNavigationHost: View {
    var item: NCCNavigationContentItem

    var body: some View {
        item.view.animation(.easeInOut)
    }
}
