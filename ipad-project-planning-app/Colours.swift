
//
//  Colours.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/14/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import Foundation
import UIKit

public class Colours {
    public func getProgressGradient(_ percentage: Int, negative: Bool = false) -> [UIColor] {
        let _default: [UIColor] = [UIColor.red, UIColor.orange]
        
        if !negative {
            if percentage <= 33 {
                return [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.00), UIColor(red: 255/255, green: 69/255, blue: 69/255, alpha: 1.00)]
            } else if percentage <= 66 {
                return [UIColor(red: 255/255, green: 126/255, blue: 0/255, alpha: 1.00), UIColor(red: 255/255, green: 155/255, blue: 57/255, alpha: 1.00)]
            } else if percentage <= 100 {
                return [UIColor(red: 50/255, green: 200/255, blue: 0/255, alpha: 1.00), UIColor(red: 151/255, green: 255/255, blue: 49/255, alpha: 1.00)]
            }
            return _default
        } else {
            if percentage <= 33 {
                return [UIColor(red: 50/255, green: 200/255, blue: 0/255, alpha: 1.00), UIColor(red: 151/255, green: 255/255, blue: 49/255, alpha: 1.00)]
            } else if percentage <= 66 {
                return [UIColor(red: 255/255, green: 126/255, blue: 0/255, alpha: 1.00), UIColor(red: 255/255, green: 155/255, blue: 57/255, alpha: 1.00)]
            } else if percentage <= 100 {
                return [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.00), UIColor(red: 255/255, green: 69/255, blue: 69/255, alpha: 1.00)]
            }
            return _default
        }
        return _default
    }
}
