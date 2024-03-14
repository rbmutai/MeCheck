//
//  UIFont+CustomFont.swift
//  MeCheck
//
//  Created by Robert Mutai on 14/03/2024.
//

import Foundation
import SwiftUI
extension Font {
    static func IBMRegular(size: CGFloat) -> Font {
      return .custom("IBMPlexSans-Regular", size: size)
    }
    
    static func IBMMedium(size: CGFloat) -> Font {
      return .custom("IBMPlexSans-Medium", size: size)
    }
    
    static func IBMSemiBold(size: CGFloat) -> Font {
      return .custom("IBMPlexSans-SemiBold", size: size)
    }
}
