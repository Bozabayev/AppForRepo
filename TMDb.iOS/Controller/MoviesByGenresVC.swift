//
//  MoviesByGenresVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/8/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya


class MoviesByGenresVC: UIViewController {

    
    var genreId : Int?
    fileprivate var movies = [Movie]()
    fileprivate var selectedMovie : Movie?
    fileprivate var provider = MoyaProvider<MovieListService>()
    let nib = UINib(nibName: "MovieGenresCell", bundle: nil)
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(nib, forCellWithReuseIdentifier: "movieGenresCell")
        loadMoviesByGenreId()
        // Do any additional setup after loading the view.
    }
    
    private func loadMoviesByGenreId(){
        guard let id = genreId else {return}
        provider.request(.discoverGenreList(genre_id: id)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.movies = array.map({Movie(JSON: $0)!})
                    strongSelf.collectionView.reloadData()
                    print(array)
                } catch {
                    print("error")
                }
            case .failure(let error):
                print("Mapping error: \(error)")
            }
        }
    }

}

extension MoviesByGenresVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieGenresCell", for: indexPath) as? MovieGenresCell {
            let movie = self.movies[indexPath.row]
            cell.configureCell(movie: movie)
            return cell
        } else{
        return UICollectionViewCell()
    }
    
    
    }
    
    
    
    
    
    
}
