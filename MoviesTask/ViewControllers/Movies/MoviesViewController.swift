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
    lazy var loadingView : UIAlertController = {
        
       return UIAlertController(title: "", message: nil, preferredStyle: .alert)
    }()
    
    let pageSize = 20
    let userMovies = 0
    lazy var viewModel: MoviesViewModel = {
        let moviesViewModel = MoviesViewModel()
        return moviesViewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView()
        self.setupViewModel()
        
    }
    func setupViewModel(){
        self.startLoading()
        self.viewModel.getMovies()
       
        self.viewModel.userAdderMovies.addObserver(self) { [weak self] in
           
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
        self.viewModel.movies.addObserver(self) { [weak self] in
            self?.stopLoading()
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
    }
    
    func setupTableView(){
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        self.moviesTableView.estimatedRowHeight = 100
        self.moviesTableView.rowHeight = UITableView.automaticDimension
        
        self.moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        self.moviesTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        
    }
    @IBAction func btnAddMoviePressed(_ sender: Any) {
        
        if let addMovieVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMovieViewController") as? AddMovieViewController {
            addMovieVC.delegate = self.viewModel
            self.present(addMovieVC, animated: true, completion: nil)
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.numberOfRowsForUserAddedMovies > 0 && section == 0 {
            return self.viewModel.numberOfRowsForUserAddedMovies
        }
        return self.viewModel.numberOfRowsForMovies
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfRowsForUserAddedMovies > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.viewModel.numberOfRowsForUserAddedMovies > 0 && section == 0 {
            return "My Movies"
        }
        return "Movies"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == (self.viewModel.movies.value?.count ?? 0 - 1) && self.viewModel.isPaging {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as? LoadingTableViewCell {
                self.viewModel.getMovies()
                cell.loadingActivityIndicator.startAnimating()
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell",for: indexPath) as? MovieTableViewCell {
            var movie : Movie?
            if self.viewModel.numberOfRowsForUserAddedMovies > 0 && indexPath.section == 0 {
                movie = self.viewModel.userAdderMovies.value?[indexPath.row]
                cell.movie = movie
                return cell
                
            }
            movie = self.viewModel.movies.value?[indexPath.row]
            cell.movie = movie
            return cell
        }
       
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let movieCell = cell as? MovieTableViewCell {
           let urlString = self.viewModel.movies.value?[indexPath.row].posterPath
            movieCell.imgPoster.cancelTask(for: "\(urlString ?? "")")
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
