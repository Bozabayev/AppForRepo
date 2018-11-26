//
//  UserCollectionView.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/26/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit



protocol FavoriteMoviesDelegate {
    func favoriteMoviesBtn()
}

class UserCollectionView: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let nib = UINib(nibName: "MovieDetailCollectionCell", bundle: nil)
    var delegateBtn : FavoriteMoviesDelegate?
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
       collectionView.register(nib, forCellWithReuseIdentifier: "MovieDetailCollectionCell")
    collectionView.reloadData()
    }

   
    @IBAction func favoriteMoviesPressed(_ sender: Any) {
        delegateBtn?.favoriteMoviesBtn()
    }
    
}
