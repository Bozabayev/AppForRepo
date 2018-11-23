//
//  AccountAuthorizationCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

protocol LoginButtonTapDelegate {
    func loginTapButton()
}

protocol LoginTextDelegate{
    func loginTextDelegate(username: String, password: String)
}

class AccountAuthorizationCell: UITableViewCell, UITextFieldDelegate {
    
    
    @IBOutlet weak var userNameTxtAuth: UITextField!
    
    @IBOutlet weak var passwordTxtAuth: UITextField!
    
    var delegate : LoginButtonTapDelegate?
    var delegateText : LoginTextDelegate?
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        userNameTxtAuth.delegate = self
        passwordTxtAuth.delegate = self
    }

  
    @IBAction func loginBtnPressed(_ sender: Any) {
        delegate?.loginTapButton()
    }
    
   
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegateText?.loginTextDelegate(username: userNameTxtAuth.text!, password: passwordTxtAuth.text!)
    }
    
}
