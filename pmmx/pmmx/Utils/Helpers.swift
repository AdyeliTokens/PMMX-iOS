//
//  Functions.swift
//  pmmx
//
//  Created by ISPMMX on 2/2/18.
//  Copyright © 2018 com.pmi. All rights reserved.
//

import Foundation

extension UIColor {
    static func color(displayP3Red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            red: CGFloat(Float(1.0) / Float(255.0) * Float(displayP3Red)),
            green: CGFloat(Float(1.0) / Float(255.0) * Float(green)),
            blue: CGFloat(Float(1.0) / Float(255.0) * Float(blue)),
            alpha: CGFloat(alpha))
    }
}

class Helpers: UIViewController
{
    func randomColor(seed: String) -> UIColor
    {
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 3)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 6)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
