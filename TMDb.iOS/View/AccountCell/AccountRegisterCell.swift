//
//  AccountRegisterCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

protocol CreateAccButtonTapDelegate {
    func createTapButton()
}


protocol CreateAccTextDelegate{
    func createAccTextDelegate(username: String, password: String)
}

class AccountRegisterCell: UITableViewCell, UITextFieldDelegate {
    
    
    @IBOutlet weak var userNameTxtReg: UITextField!
    
    @IBOutlet weak var passwordTxtReg: UITextField!
    
    var delegate : CreateAccButtonTapDelegate?
    var delegateText : CreateAccTextDelegate?
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        userNameTxtReg.delegate = self
        passwordTxtReg.delegate = self
    }

   
    @IBAction func createAccBtnPressed(_ sender: Any) {
        delegate?.createTapButton()
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        delegateText?.createAccTextDelegate(username: userNameTxtReg.text!, password: passwordTxtReg.text!)
    }
    
    
  
    
   
    
  
    
}
