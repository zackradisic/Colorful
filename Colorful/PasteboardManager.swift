//
//  Clipboard.swift
//  Colorful
//
//  Created by Zack Radisic on 2020-06-24.
//  Copyright © 2020 Zack Radisic. All rights reserved.
//

import Cocoa
import AppKit

class PasteboardManager: NSObject {
  
  private let pasteboard = NSPasteboard.general
  private var changeCount = 0
  
  func listenForChanges() {
    Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.convertIfChanged), userInfo: nil, repeats: true)
  }
  
  @objc func convertIfChanged() {
    if changeCount == pasteboard.changeCount {
      return
    }
    
    self.convert()
    
    changeCount = pasteboard.changeCount
  }
  
  func convert() {
    guard let items = pasteboard.pasteboardItems else {
      return
    }
    
    items.forEach({ item in
      guard let content = item.string(forType: NSPasteboard.PasteboardType.string) else {
        return
      }
      
      guard let type = Color.getType(input: content) else {
        return
      }
      
      if type == ColorfulState.encodingType {
        return
      }
      
      guard let transcoded = Color.convert(input: content, from: type, to: ColorfulState.encodingType) else {
        
        return
      }
      
      pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
      pasteboard.setString(transcoded, forType: NSPasteboard.PasteboardType.string)
    })
  }
  
}
