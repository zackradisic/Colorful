//
//  ColorEncoding.swift
//  Colorful
//
//  Created by Zack Radisic on 2020-06-24.
//  Copyright © 2020 Zack Radisic. All rights reserved.
//

import Foundation

class Color: NSObject {
    
    public enum EncodingType {
        case RGB
        case RGBA
        case Hex
        case HSL
        
        func toString() -> String {
            return "\(self)"
        }
    }
    
    private static let hexRegex = try! NSRegularExpression(pattern: "^#[0-9a-f]{3}([0-9a-f]{3})?$")
    private static let rgbRegex = try! NSRegularExpression(pattern: "^rgb\\(\\s*(0|[1-9]\\d?|1\\d\\d?|2[0-4]\\d|25[0-5])%?\\s*,\\s*(0|[1-9]\\d?|1\\d\\d?|2[0-4]\\d|25[0-5])%?\\s*,\\s*(0|[1-9]\\d?|1\\d\\d?|2[0-4]\\d|25[0-5])%?\\s*\\)$")
    private static let rgbaRegex = try! NSRegularExpression(pattern: "^rgba\\(\\s*(0|[1-9]\\d?|1\\d\\d?|2[0-4]\\d|25[0-5])%?\\s*,\\s*(0|[1-9]\\d?|1\\d\\d?|2[0-4]\\d|25[0-5])%?\\s*,\\s*(0|[1-9]\\d?|1\\d\\d?|2[0-4]\\d|25[0-5])%?\\s*,\\s*((0.[1-9])|[01])\\s*\\)$")
    private static let hslRegex = try! NSRegularExpression(pattern: "^hsl\\(\\s*(0|[1-9]\\d?|[12]\\d\\d|3[0-5]\\d)\\s*,\\s*((0|[1-9]\\d?|100)%)\\s*,\\s*((0|[1-9]\\d?|100)%)\\s*\\)$")
    
    static func getType(input: String) -> EncodingType? {
        let range = NSRange(location: 0, length: input.count)
        
        if hexRegex.firstMatch(in: input, options: [], range: range) != nil {
            return EncodingType.Hex
        }
        
        if rgbRegex.firstMatch(in: input, options: [], range: range) != nil {
            return EncodingType.RGB
        }
        
        if rgbaRegex.firstMatch(in: input, options: [], range: range) != nil {
            return EncodingType.RGBA
        }
        
        if hslRegex.firstMatch(in: input, options: [], range: range) != nil {
            return EncodingType.HSL
        }
        
        return nil
    }
    
    static func getValue(input: String, encodingType: EncodingType) -> Int {
        switch encodingType {
        case EncodingType.Hex:
            return getHexValue(input: input)
        case EncodingType.RGB:
            return getRGBValue(input: input)
        default:
            return -1
        }
    }
    
    static func getHexValue(input: String) -> Int {
        Int(input.replacingOccurrences(of: "#", with: ""), radix: 16)!
    }
    
    static func toHex(input: Int) -> String {
        var s = String(input, radix: 16)
        if s.count < 6 {
            for _ in 0..<6-s.count {
                s = "0" + s
            }
        }
        
        return "#" + s
    }
    
    static func toRGB(input: Int) -> String {
        // Shift the bits to the right by the appropriate amount,
        // and apply a bit mask of 255 to isolate the bits we want.
        let r = (input >> 16) & 0xFF
        let g = (input >> 8) & 0xFF
        let b = input & 0xFF
        
        return "rgb(\(r), \(b), \(g))"
    }
    
    static func getRGBValue(input: String) -> Int {
        let result = rgbRegex.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))
        
        var shift = 16
        return [1, 2, 3].map({ index in
            result[0].range(at: index)
        }).map({ range -> Int in
            Int(String(input.substring(range.location, range.location + range.length)))!
        }).reduce(0, { (result, val) -> Int in
            let r = val << shift
            shift -= 8
            
            return r + result
        })
    }
    
    static func convert(input: String, from: EncodingType, to: EncodingType) -> String? {
        if (from == to) {
            return nil
        }
        
        let value = getValue(input: input, encodingType: from)
        
        switch to {
        case .RGB:
            return toRGB(input: value)
        case .Hex:
            return toHex(input: value)
        case .RGBA:
            return nil
        case .HSL:
            return nil
        }
    }
}

extension String {
    func substring (_ lowerBound: Int, _ upperBound: Int) -> String {
        let start = index(startIndex, offsetBy: lowerBound)
        let end = index(startIndex, offsetBy: upperBound)
        return String(self[start..<end])
    }
}
