//
//  MovieCell.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/6/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var overviewLbl: UILabel!
    

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        posterImg.layer.cornerRadius = 7
        posterImg.clipsToBounds = true
        
        
    }
    
    

 
    func configureCell(movie: Movie) {
        let title = movie.title
        movieTitle.text = title
        
        guard let rating = movie.vote_average else {return}
        if rating == 0.0 {
            ratingValue.text = "--"
        } else {
        ratingValue.text = "\(String(describing: rating))"
        }
        let overview = movie.overview
        overviewLbl.text = overview
        
        guard let poster_path = movie.poster_path else {return}
         let URL_IMAGE = "https://image.tmdb.org/t/p/w500/\(String(describing: (poster_path)))"
        posterImg.sd_setImage(with: URL(string: URL_IMAGE)) { [weak self](image, error, cacheType, imageURL) in
            guard let strongSelf = self else {return}
            strongSelf.posterImg.image = image
            
        }
    }
    
    
  

    
    
}
