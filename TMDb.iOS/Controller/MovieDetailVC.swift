//
//  MovieDetailVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/8/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya

var pageNumberOfSimilarMovies : Int? = 1



class MovieDetailVC: UIViewController {

    
    var movieDetail : Movie?
    var movies = [Movie]()
    var casts = [Cast]()
    let nibDetail = UINib(nibName: "MovieDetailCell", bundle: nil)
    let nibCollection = UINib(nibName: "MovieDetailCollection", bundle: nil)
    let provider = MoyaProvider<MovieListService>()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibDetail, forCellReuseIdentifier: "MovieDetailCell")
        tableView.register(nibCollection, forCellReuseIdentifier: "MovieDetailCollection")

        
    }
    
    
    func loadMovieCast() {
        guard let id = movieDetail?.id else {return}
        provider.request(.movieCast(movie_id: id)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do{
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.casts = array.map({Cast(JSON: $0)!})
                    
                    
                }catch {
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        
        
        
    }
    

   

}

extension MovieDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let firstIndex = IndexPath(row: 0, section: 0)
        let secondIndex = IndexPath(row: 1, section: 0)
        
        if firstIndex == indexPath{
            if let firstCell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell", for: firstIndex) as? MovieDetailCell {
                guard let unwMovie = movieDetail else {return UITableViewCell()}
                firstCell.configureCell(movie: unwMovie)
                return firstCell
            }else {
                return UITableViewCell()
            }
        }else if secondIndex == indexPath{
            if let secondCell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCollection", for: secondIndex) as? MovieDetailCollection {
                
                secondCell.collectionView.delegate = self
                secondCell.collectionView.dataSource = self
                return secondCell
            }
            return UITableViewCell()
        }
        
           else {
            return UITableViewCell()
        }
       
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    }

extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionCell", for: indexPath) as? MovieDetailCollectionCell {
            let cast = casts[indexPath.row]
            cell.configureCell(cast: cast)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
    
    
    
    


    
    
    





