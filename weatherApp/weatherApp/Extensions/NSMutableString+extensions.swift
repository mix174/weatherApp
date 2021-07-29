//
//  NSMutableString+extensions.swift
//  weatherApp
//
//  Created by Mix174 on 28.07.2021.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    // Заменено внутренними реализациями функций для управления размером шрифта в каждом случае
//    var fontSize: CGFloat { return 21 }
//    var boldFont: UIFont { return UIFont(name: "Roboto-Medium", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
//    var normalFont:UIFont { return UIFont(name: "Roboto-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "Roboto-Medium", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont(name: "Roboto-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    // YAGNI
    /* Other styling methods */
    func orangeHighlight(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  UIFont(name: "Roboto-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font: UIFont(name: "Roboto-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value: String, fontSize: CGFloat) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font: UIFont(name: "Roboto-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
