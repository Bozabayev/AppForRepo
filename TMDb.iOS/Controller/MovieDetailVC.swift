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
    var movie : Movie?
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
        loadMovieCast()
        loadSimilarMovies()
        LoadingIndicator().showActivityIndicator(uiView: self.view)
        navigationItem.title = "Movie Details"
    }

 
    
    func loadMovieCast() {
        guard let id = movieDetail?.id else {return}
        provider.request(.movieCast(movie_id: id)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do{
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["cast"] as! [[String: Any]]
                    strongSelf.casts = array.map({Cast(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                    
                }catch {
                    print("Mapping error")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    
    func loadSimilarMovies() {
        guard let id = movieDetail?.id else {return}
        provider.request(.similarMovies(movie_id: id)) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.movies = array.map({Movie(JSON: $0)!})
                    print(strongSelf.movies.count)
                    strongSelf.tableView.reloadData()
                    LoadingIndicator().hideActivityIndicator(uiView: strongSelf.view)
                } catch {
                    
                }
            case .failure(let error):
                print("Error : \(error)")
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
        let thirdIndex = IndexPath(row: 2, section: 0)
        
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
                secondCell.collectionView.tag = 1
                secondCell.collectionViewTitle.text = "Movie Cast"
                secondCell.collectionView.dataSource = self
                secondCell.collectionView.delegate = self
                secondCell.collectionView.reloadData()
                return secondCell
            }
            return UITableViewCell()
        } else if thirdIndex == indexPath && movies.count != 0 {
            if let thirdCell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCollection", for: thirdIndex) as? MovieDetailCollection {
                thirdCell.collectionView.tag = 2
                thirdCell.collectionViewTitle.text = "Similar Movies"
                thirdCell.collectionView.delegate = self
                thirdCell.collectionView.dataSource = self
                thirdCell.collectionView.reloadData()
                return thirdCell
            }
            return UITableViewCell()
        }
        
           else {
            return UITableViewCell()
        }
       
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 220
        case 2:
            if movies.count != 0 {
            return 220
            } else {
                return 0
            }
        default:
            return UITableView.automaticDimension
        }
        
    }
        
    }

extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return casts.count
        case 2:
            return movies.count
        default:
            return casts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        switch collectionView.tag {
        case 1:
            if let secondCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionCell", for: indexPath) as? MovieDetailCollectionCell {
            let cast = casts[indexPath.row]
            secondCell.configureCell(cast: cast)
            return secondCell
            }
        case 2 :
            if let thirdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionCell", for: indexPath) as? MovieDetailCollectionCell {
                let movie = movies[indexPath.row]
                thirdCell.configureCellForSimilarMovies(movie: movie)
                return thirdCell
    }
       
        default:
             return UICollectionViewCell()
        }
        
         return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ActorDetailVC") as! ActorDetailVC
            vc.personId = casts[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
          movie = movies[indexPath.row]
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
          vc.movieDetail = movie
          self.navigationController!.pushViewController(vc, animated: true)
        
        default:
            return
        }
    }
    
    
    
    
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

    

    


    
    
    





