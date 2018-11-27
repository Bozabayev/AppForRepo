//
//  FavoriteMoviesVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/26/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya
class FavoriteMoviesVC: UIViewController {

    
    var movies = [Movie]()
    @IBOutlet weak var collectionView: UICollectionView!
    let providerAccount = MoyaProvider<AccountService>()
    let nib = UINib(nibName: "MovieGenresCell", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieGenresCell")
        loadFavoriteMovies()
        navigationItem.title = "Favorite Movies"
        
    }
    

   
    func loadFavoriteMovies() {
        providerAccount.request(.getFavoriteMovies(accountID: UserDataService.instance.accountID)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String : Any]]
                    strongSelf.movies = array.map({Movie(JSON: $0)!})
                    strongSelf.collectionView.reloadData()
                } catch {
                    print("Mapping error")
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
  

}

extension FavoriteMoviesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGenresCell", for: indexPath) as? MovieGenresCell {
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
