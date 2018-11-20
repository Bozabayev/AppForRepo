//
//  MovieDetailCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/20/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var posterTitle: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    


    
    
    func configureCell(movie: Movie) {
        guard let title = movie.title else {return}
        posterTitle?.text = title
        guard let overview = movie.overview else {return}
        overView.text = overview
        
        
        guard let poster_path = movie.poster_path else {return}
        let URL_IMAGE = "https://image.tmdb.org/t/p/w500/\(String(describing: (poster_path)))"
        posterImg.sd_setImage(with: URL(string: URL_IMAGE)) { [weak self](image, error, cacheType, imageURL) in
            guard let strongSelf = self else {return}
            strongSelf.posterImg.image = image
            
        }

}
}
