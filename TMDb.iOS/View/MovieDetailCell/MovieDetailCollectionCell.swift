//
//  MovieDetailCollectionCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/20/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var actorNameLbl: UILabel!
    
    @IBOutlet weak var collectionCellImg: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(cast: Cast) {
        guard let name = cast.name else {return}
        actorNameLbl.text = name
        
        guard let profile_path = cast.profile_path else {return}
        let URL_IMAGE = "https://image.tmdb.org/t/p/w500/\(String(describing: (profile_path)))"
        collectionCellImg.sd_setImage(with: URL(string: URL_IMAGE)) { [weak self](image, error, cacheType, imageURL) in
            guard let strongSelf = self else {return}
            strongSelf.collectionCellImg.image = image
    }
}

}
