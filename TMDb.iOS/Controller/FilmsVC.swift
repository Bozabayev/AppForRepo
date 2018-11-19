//
//  FilmsVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/6/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit
import Moya



class FilmsVC: UIViewController {
    
    
    
    fileprivate enum MovieType{
        case popular
        case upcoming
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Private variables
    fileprivate var popularMovies = [Movie]()
    fileprivate var upcomingMovies = [Movie]()
    fileprivate var selectedMovie: Movie?
    fileprivate let provider = MoyaProvider<MovieListService>()
    fileprivate var movie : Movie?
    fileprivate var movieType = MovieType.popular{
        didSet{
            tableView.reloadData()
        }
    }
    let nib = UINib(nibName: "MovieCell", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadPopularMovies()
        loadUpcomingMovies()
        self.tableView.register(nib, forCellReuseIdentifier: "movieCell")
        self.tableView.rowHeight = 170.0
    }
    
    @IBAction func segmentControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            movieType = .popular
        case 1:
            movieType = .upcoming
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMovieDetailFromMovies"{
            guard let vc = segue.destination as? MovieDetailVC else {return}
            vc.movie = sender as? Movie
        }
    }
    
    private func loadPopularMovies() {
        self.popularMovies.removeAll()
        provider.request(.popularList) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String: Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.popularMovies = array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                } catch {
                    print("Mapping Error")
                }
            case . failure(let error):
                print("Server error: \(error)")
            }
        }
    }
    
    private func loadUpcomingMovies() {
        self.upcomingMovies.removeAll()
        provider.request(.upcomingList) { [weak self](result) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                do {
                    let jsonData = try response.mapJSON() as! [String:Any]
                    let array = jsonData["results"] as! [[String: Any]]
                    strongSelf.upcomingMovies = array.map({Movie(JSON: $0)!})
                    strongSelf.tableView.reloadData()
                } catch {
                    print("Mapping Error")
                }
            case . failure(let error):
                print("server error: \(error)")
            }
        }
    }
    
    
}

extension FilmsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieType == .popular ? self.popularMovies.count : self.upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell {
            if movieType == .popular {
                movie = popularMovies[indexPath.row]
            }else {
                movie = upcomingMovies[indexPath.row]
            }
            guard let unwMovie = movie else {return UITableViewCell()}
            cell.configureCell(movie: unwMovie)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if movieType == .popular{
            movie = self.popularMovies[indexPath.row]
        }else {
            movie = self.upcomingMovies[indexPath.row]
        }
        guard let unwMovie = movie else {return}
        self.selectedMovie = unwMovie
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        performSegue(withIdentifier: "toMovieDetailFromMovies", sender: movie)
    }
    
    
    
}
