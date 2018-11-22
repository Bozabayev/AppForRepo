//
//  ActorDetailCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/21/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import SDWebImage

class ActorDetailCell: UITableViewCell {

    @IBOutlet weak var actorNameLbl: UILabel!
    @IBOutlet weak var biographyLbl: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            }
    
    func configureCell(cast: Cast) {
        actorNameLbl.text = cast.name
        
        if cast.biography == nil || cast.biography == "" {
            biographyLbl.text = ""
        }else {
            biographyLbl.text = "Biography: \(String(describing: cast.biography!))"
        }
        
        if cast.profile_path == nil {
            posterImg.image = #imageLiteral(resourceName: "placeholder.png")
        } else {
        
        guard let profile_path = cast.profile_path else {return}
        let URL_IMAGE = "https://image.tmdb.org/t/p/w500/\(String(describing: (profile_path)))"
        posterImg.sd_setImage(with: URL(string: URL_IMAGE)) { [weak self](image, error, cacheType, imageURL) in
            guard let strongSelf = self else {return}
            strongSelf.posterImg.image = image
        }
}
        
        
        
    }
    
    
    

   
    
}
