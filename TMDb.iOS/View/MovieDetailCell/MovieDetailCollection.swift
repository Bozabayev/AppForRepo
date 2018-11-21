//
//  MovieDetailCollection.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/20/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya

class MovieDetailCollection: UITableViewCell {
    
    

    let nib = UINib(nibName: "MovieDetailCollectionCell", bundle: .main)


   
    @IBOutlet weak var collectionViewTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieDetailCollectionCell")
        self.collectionView.reloadData()
    }
    
}
