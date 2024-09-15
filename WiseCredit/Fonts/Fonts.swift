//
//  Fonts.swift
//  WiseCredit
//
//  Created by Enrique Macias on 9/14/24.
//

import SwiftUI

struct CustomFonts {
    
    // Poppins Font Weights
    static func PoppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func PoppinsMedium(size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
    
    static func PoppinsSemiBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-SemiBold", size: size)
    }
    
    static func PoppinsBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-Bold", size: size)
    }
    
    static func PoppinsExtraBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-ExtraBold", size: size)
    }
}
