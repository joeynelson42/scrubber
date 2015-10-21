//
//  UIColor+Flashcards.swift
//  TALL Shell
//
//  Created by Nelson, J. Edmond on 4/2/15.
//  Copyright (c) 2015 MTC. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    class func fromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    class func flashcardsBlue() -> UIColor{
        let color = UIColor.fromHex(0x4696F5, alpha: 1.0)
        return color
    }
    
    // DRAWER COLORS
    class func selectedBlue() -> UIColor {
        return UIColor(red:0.25, green:0.58, blue:0.97, alpha:1)
    }
    
    class func drawerDarkestGray() -> UIColor {
        return UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
    }
    
    class func drawerDarkGray() -> UIColor {
        return UIColor(red:0.28, green:0.28, blue:0.28, alpha:1)
    }
    
    class func drawerDarkSeparatorGray() -> UIColor {
        return UIColor(red:0.27, green:0.26, blue:0.26, alpha:1)
    }
    
    class func drawerTableCellGray() -> UIColor {
        return UIColor(red:0.34, green:0.34, blue:0.34, alpha:1)
    }
    
    class func drawerMediumSepatatorGray() -> UIColor {
        return UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
    }
    
    class func drawerMediumGray() -> UIColor {
        return UIColor(red:0.38, green:0.38, blue:0.38, alpha:1)
    }
    
    class func drawerTableSeparatorGray() -> UIColor {
        return UIColor(red:0.44, green:0.44, blue:0.44, alpha:1)
    }
    
    class func drawerLightGray() -> UIColor {
        return UIColor(red:0.48, green:0.48, blue:0.48, alpha:1)
    }
    
    class func drawerButtonTextHighlightedGray() -> UIColor {
        return UIColor(red:0.51, green:0.51, blue:0.51, alpha:1)
    }
    
    class func drawerButtonTextNormalGray() -> UIColor {
        return UIColor(red:0.88, green:0.88, blue:0.88, alpha:1)
    }
    
    class func stringToHex(s: NSString)->Int{
        let numbers = [
            "a": 10, "A": 10,
            "b": 11, "B": 11,
            "c": 12, "C": 12,
            "d": 13, "D": 13,
            "e": 14, "E": 14,
            "f": 15, "F": 15,
            "0": 0
        ]
        
        var number: Int = Int()
        if(s.intValue > 0){
            number = s.integerValue
        }
        else{
            number = numbers[s as String]!
        }
        return number
    }
    
    class func ColorFromRedGreenBlue(red: NSString, green: NSString, blue: NSString)->UIColor{
        
        var first: NSString = red.substringToIndex(1)
        var second = red.substringFromIndex(1)
        var varOne = stringToHex(first)
        var varTwo = stringToHex(second)
        let redValue: CGFloat = (CGFloat(varOne) * 16.0 + CGFloat(varTwo)) / 255.0
        
        first = green.substringToIndex(1)
        second = green.substringFromIndex(1)
        varOne = stringToHex(first)
        varTwo = stringToHex(second)
        let greenValue: CGFloat = (CGFloat(varOne) * 16.0 + CGFloat(varTwo)) / 255.0
        
        first = blue.substringToIndex(1)
        second = blue.substringFromIndex(1)
        varOne = stringToHex(first)
        varTwo = stringToHex(second)
        let blueValue: CGFloat = (CGFloat(varOne) * 16.0 + CGFloat(varTwo)) / 255.0
        
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
    
    class func languageCellColor(hex: String)->UIColor{
        var color = NSAttributedString(string: hex)
        var range = NSMakeRange(1, color.length - 1)
        color = color.attributedSubstringFromRange(range)
        range = NSMakeRange(0, 2)
        let red = color.attributedSubstringFromRange(range)
        range = NSMakeRange(2, 2)
        let green = color.attributedSubstringFromRange(range)
        range = NSMakeRange(4, 2)
        let blue = color.attributedSubstringFromRange(range)
        return ColorFromRedGreenBlue(red.string, green: green.string, blue: blue.string)
    }
}




extension CGColor{
    class func fromHex(rgbValue:UInt32, alpha:Double=1.0) -> CGColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha)).CGColor
        
        return color
    }
    
    class func flashcardsBlue() -> CGColor{
        let color = CGColor.fromHex(0x4696F5, alpha: 1.0)
        return color
    }
}