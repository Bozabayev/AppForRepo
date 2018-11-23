//
//  MoviesByGenresVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/8/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya

var genreId : Int?
var genreName : String?

class MoviesByGenresVC: UIViewController {

    
    var pageNumberOfMoviesByGenre : Int? = 1
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
        navigationItem.title = genreName?.capitalizingFirstLetter()
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem

        // Do any additional setup after loading the view.
    }
    
    private func loadMoviesByGenreId() {
        guard let id = genreId else {return}
        guard let page = pageNumberOfMoviesByGenre else {return}
        provider.request(.discoverGenreList(genre_id: id, page: page)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.movies += array.map({Movie(JSON: $0)!})
                    strongSelf.collectionView.reloadData()
                } catch {
                    print("error")
                }
            case .failure(let error):
                print("Mapping error: \(error)")
            }
        }
    }

}

extension MoviesByGenresVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if movies.count == indexPath.row + 2 {
            pageNumberOfMoviesByGenre! += 1
            loadMoviesByGenreId()
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieGenresCell", for: indexPath) as? MovieGenresCell {
            let movie = self.movies[indexPath.row]
            cell.layer.cornerRadius = 7
            cell.configureCell(movie: movie)
            return cell
        } else{
        return UICollectionViewCell()
    }
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        vc.movieDetail = movies[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}



