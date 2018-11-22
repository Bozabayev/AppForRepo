//
//  AccountAuthorizationCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

class AccountAuthorizationCell: UITableViewCell {
    
    
    @IBOutlet weak var userNameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
    @IBAction func loginBtnPressed(_ sender: Any) {
    }
    
    
    func configureAccount(account: Account) {
        if (userNameTxt.text!.count) > 0 && (passwordTxt.text!.count) > 0 {
        account.username = userNameTxt.text
        account.password = passwordTxt.text
        }
    
    }
    
}
