//
//  SegmentedControl.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/30/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit


class CustomSegmentedControl: UIControl {
    
    var buttons = [UIButton]()
    var selector : UIView!
    var selectedSegmentIndex = 0
    
    var borderWidth  : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
     var borderColor : UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    var commaSeparatedButtonTitles : String = "" {
        didSet {
           updateView()
        }
    }
    
    var textColor : UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    var selectorColor : UIColor = UIColor.black {
        didSet {
            updateView()
        }
    }

    var selectorTextColor : UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
    }
    
    
    @objc func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == button {
                self.selectedSegmentIndex = buttonIndex
                let selectorPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let buttonTitles =  commaSeparatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    
    
    
    

}
