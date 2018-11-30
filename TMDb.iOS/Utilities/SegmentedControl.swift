//
//  CustomSegmentedControl.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/30/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

@IBDesignable

class CustomSegmentedControl: UIView {
    
    @IBInspectable
    var borderWidth  = 0 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable
    var borderColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    

    
    
    func updateView() {
        layer.cornerRadius = frame.height / 2
        
        
        
        
        
    }
    
    
    
    
    

}
