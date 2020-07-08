//
//  NCCNavigation.swift
//  NCCNavigation
//
//  Created by Andrew Benson on 7/8/20.
//  Copyright © 2020 Nuclear Cyborg Corp. All rights reserved.
//


let isDebugOutputEnabled = true
func debugOutput(_ s: String, file: String = #file, function: String = #function) {
    let trimmedFile = file.split(separator: "/").last!
    if isDebugOutputEnabled {
        print("\(trimmedFile): \(function): \(s)")
    }
}
