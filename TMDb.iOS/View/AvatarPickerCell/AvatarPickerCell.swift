//
//  AvatarPickerCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/25/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

class AvatarPickerCell: UICollectionViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       setUpView()
    }
    
    
    
    func configureCell(index: Int){
        avatarImg.image = UIImage(named: "dark\(index)")
        self.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    func setUpView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }

}
