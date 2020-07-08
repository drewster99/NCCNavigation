//
//  NCCNavigationManagerKey.swift
//  NCCNavigationView
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//

import Foundation
import SwiftUI

struct NCCNavigationManagerKey: EnvironmentKey {
    static let defaultValue: NCCNavigationManager = {
        NCCNavigationManager.defaultManager
    }()
}

extension EnvironmentValues {
    var nccNavigationManager: NCCNavigationManager {
        get {
            return self[NCCNavigationManagerKey.self]
        }
        set {
            self[NCCNavigationManagerKey.self] = newValue
        }
    }
}
