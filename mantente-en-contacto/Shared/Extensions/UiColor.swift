//
//  UiColor.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import UIKit

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let ri = Int(r * 255)
        let gi = Int(g * 255)
        let bi = Int(b * 255)
        
        // %02X Imprime en hexadecimal un numero
        return String(format: "#%02X%02X%02X", ri, gi, bi)
    }
}
