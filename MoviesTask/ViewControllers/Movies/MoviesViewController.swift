//
//  MoviesViewController.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    let pageSize = 20
    let userMovies = 3
    var movie : MovieResponse? {
        didSet {
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView()
        
        let webRepo = WebMovieRepository().get(page: 1) { (movie, error) in
            
            self.movie = movie
        }
    }
    
    func setupTableView(){
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        self.moviesTableView.estimatedRowHeight = 300
        self.moviesTableView.rowHeight = UITableView.automaticDimension
        
        self.moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        self.moviesTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        
    }
    @IBAction func btnAddMoviePressed(_ sender: Any) {
        
        if let addMovieVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMovieViewController") as? AddMovieViewController {
            
            self.present(addMovieVC, animated: true, completion: nil)
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userMovies > 0 && section == 0 {
            return userMovies
        }
        return self.movie?.movies?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userMovies > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if userMovies > 0 && section == 0 {
            return "My Movies"
        }
        return "Movies"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == pageSize - 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as? LoadingTableViewCell {
                
                cell.loadingActivityIndicator.startAnimating()
                return cell
            }
        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as? MovieTableViewCell {
                let movie = self.movie?.movies?[indexPath.row]
                cell.imageStr = "https://image.tmdb.org/t/p/w185\(movie?.posterPath ?? "")"
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            view.backgroundColor = .black
        }
        
    }
    
}
