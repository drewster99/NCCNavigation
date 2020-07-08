//
//  NCCNavigationContentItem.swift
//  NCCNavigation
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import SwiftUI

struct NCCNavigationContentItem: Identifiable {
    let id: String
    let view: AnyView
    let onDismiss: () -> Void
}
