//
//  StatusBarController.swift
//  Colorful
//
//  Created by Zack Radisic on 2020-06-24.
//  Copyright © 2020 Zack Radisic. All rights reserved.
//

import AppKit

class StatusBarController: NSObject {
    
    var statusBarItem: NSStatusItem?
    var encodingTypeMenuController: EncodingTypeMenuController?
    
    override init() {
        super.init()
        
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        statusBarItem!.button?.title = "🎨"
        
        let statusBarMenu = NSMenu(title: "Colorful")
        statusBarItem!.menu = statusBarMenu
        
        
        setupPreferredColorEndodingMenu(statusBarMenu)
        
        statusBarMenu.addItem(NSMenuItem.separator())
        let githubLink = statusBarMenu.addItem(withTitle: "Made by Zack Radisic", action: #selector(self.openGithubLink), keyEquivalent: "")
        statusBarMenu.addItem(NSMenuItem.separator())
        let quit = statusBarMenu.addItem(withTitle: "Quit Colorful", action: #selector(self.quit), keyEquivalent: "")
        
        githubLink.target = self
        quit.target = self
    }
    
    func setupPreferredColorEndodingMenu(_ statusBarMenu: NSMenu) {
        encodingTypeMenuController = EncodingTypeMenuController(target: self)
        let preferredColorEncoding = statusBarMenu.addItem(
            withTitle: "Convert colors to",
            action: nil,
            keyEquivalent: "")
        
        preferredColorEncoding.target = self
        preferredColorEncoding.submenu = encodingTypeMenuController?.menu
    }
    
    @objc func quit() {
        for runningApplication in NSWorkspace.shared.runningApplications {
            if runningApplication.localizedName == "Colorful" {
                runningApplication.terminate()
            }
        }
    }
    
    @objc func setColorEncodingType(_ item: EncodingTypeMenuItem) {
        encodingTypeMenuController?.setActive(encodingType: item.encodingType)
    }
    
    
    @objc func openGithubLink() {
        guard let url = URL(string: "https://github.com/zackradisic") else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
}
