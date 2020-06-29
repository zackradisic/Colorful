//
//  StatusBarConvertMenu.swift
//  Colorful
//
//  Created by Zack Radisic on 2020-06-25.
//  Copyright © 2020 Zack Radisic. All rights reserved.
//

import AppKit

class EncodingTypeMenuController: NSObject {
  
  let menu = NSMenu(title: "Convert colors to")
  var selectedEncodingType = Color.EncodingType.Hex
  
  init(target: AnyObject) {
    super.init()
    
    let hex = createSelectColorItem(encodingType: Color.EncodingType.Hex, target: target)
    let rgb = createSelectColorItem(encodingType: Color.EncodingType.RGB, target: target)
    let hsl = createSelectColorItem(encodingType: Color.EncodingType.HSL, target: target)

    menu.addItem(hex)
    menu.addItem(rgb)
    menu.addItem(hsl)
    menu.showsStateColumn = true
    setActive(encodingType: ColorfulState.encodingType)
    
    hex.target = target
    rgb.target = target
    hsl.target = target
  }
  
  func createSelectColorItem(encodingType: Color.EncodingType, target: AnyObject) -> NSMenuItem {
    EncodingTypeMenuItem(encodingType: encodingType, action: #selector(target.setColorEncodingType), keyEquivalent: "")
  }
  
  func setActive(encodingType: Color.EncodingType) {
    ColorfulState.encodingType = encodingType
    menu.items.forEach({ item in
      if item.state == NSControl.StateValue.on {
        item.state = NSControl.StateValue.off
      }
      
      if item.title == encodingType.toString() {
        item.state = NSControl.StateValue.on
      }
    })
  }
}

class EncodingTypeMenuItem: NSMenuItem {
  
  var encodingType: Color.EncodingType = Color.EncodingType.Hex
  
  init(encodingType: Color.EncodingType, action: Selector?, keyEquivalent: String) {
    super.init(title: encodingType.toString(), action: action, keyEquivalent: keyEquivalent)
    self.encodingType = encodingType
  }
  
  func toggleActive() {
    self.state = self.state == NSControl.StateValue.on ? NSControl.StateValue.off : NSControl.StateValue.on
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
