//
//  MovieTableViewCell.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    var webMovieCellViewModel: WebMoviesListViewModel? {
        didSet {
            self.lblTitle.text = webMovieCellViewModel?.titleText
            self.lblOverview.text = webMovieCellViewModel?.overviewText
            self.lblReleaseDate.text = webMovieCellViewModel?.releaseDateText
            self.imgPoster.image(from: webMovieCellViewModel?.imagePath ?? "")
        }
    }
    var userAdddedMovieCellViewModel: UserAddedMoviesListViewModel? {
        didSet {
            self.lblTitle.text = userAdddedMovieCellViewModel?.titleText
            self.lblOverview.text = userAdddedMovieCellViewModel?.overviewText
            self.lblReleaseDate.text = userAdddedMovieCellViewModel?.releaseDateText
           
            guard let imageData = userAdddedMovieCellViewModel?.imageData else {
                return
            }
           
            guard let posterImage = UIImage(data: imageData) else {
                return
            }
            self.imgPoster.image = posterImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
