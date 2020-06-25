//
//  Colorful.swift
//  Colorful
//
//  Created by Zack Radisic on 2020-06-24.
//  Copyright © 2020 Zack Radisic. All rights reserved.
//

import AppKit
import Cocoa

class Colorful: NSObject {
    var statusBarController: StatusBarController?
    
    override init() {
        super.init()
        
        statusBarController = StatusBarController()
        let pm = PasteboardManager()
        pm.listenForChanges()
    }
}
