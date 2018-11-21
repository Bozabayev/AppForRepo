//
//  MovieGenresCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/8/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

class MovieGenresCell: UICollectionViewCell {

    @IBOutlet weak var posterTitle: UILabel!
    
    @IBOutlet weak var posterImg: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImg.layer.cornerRadius = 7
        posterImg.clipsToBounds = true
    
        self.backgroundColor = #colorLiteral(red: 0.8010471463, green: 0.8047555089, blue: 0.8138157129, alpha: 0.5)
        
    }
    
    
    
    
    func configureCell(movie: Movie ) {
        
        
        posterTitle.text = movie.title
        
        guard let poster_path = movie.poster_path else {return}
        let URL_IMAGE = "https://image.tmdb.org/t/p/w500/\(String(describing: (poster_path)))"
        posterImg.sd_setImage(with: URL(string: URL_IMAGE)) { [weak self](image, error, cacheType, imageURL) in
            guard let strongSelf = self else {return}
            strongSelf.posterImg.image = image
        
    }
    }
}
