//
//  UserCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/23/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit


protocol ChangeAvatarDelegate: class {
    func changeAvatarButton()
}



class UserCell: UITableViewCell {
    
  
    @IBOutlet weak var ratedMoviesLbl: UILabel!
    @IBOutlet weak var favoriteMoviesLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    public weak var delegateButton : ChangeAvatarDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    
    
    }
    
        
    @IBAction func changeAvatarBtnPressed(_ sender: Any) {
        delegateButton?.changeAvatarButton()
    }
    
    func configureCell( username: String){
        userNameLbl.text = "Username: \(username)"
        
       
        
    }
    
    
    
}
