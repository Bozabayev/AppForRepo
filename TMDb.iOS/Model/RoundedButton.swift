//
//  RoundedButton.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

@IBDesignable

class RoundedButton : UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
        
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
    
    
}


