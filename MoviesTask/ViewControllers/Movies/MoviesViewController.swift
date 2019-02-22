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
    let userMovies = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView()
    }

    func setupTableView(){
        self.moviesTableView.delegate = self
        self.moviesTableView.dataSource = self
        self.moviesTableView.estimatedRowHeight = 300
        self.moviesTableView.rowHeight = UITableView.automaticDimension
        
        self.moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        self.moviesTableView.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
           return userMovies
        default:
            return pageSize
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userMovies > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "My Movies"
        default:
            return "Movies"
        }
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
            
            return cell
        }
        }
        return UITableViewCell()
    }
    
    
}
