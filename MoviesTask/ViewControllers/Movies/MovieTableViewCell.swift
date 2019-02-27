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
    
    weak var movie: Movie? {
        didSet {
          self.setupViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupViews(){
        self.lblTitle.text = self.movie?.title ?? ""
        self.lblOverview.text = self.movie?.overview ?? ""
        self.lblReleaseDate.text = self.movie?.releaseDate ?? ""

        if let imgUrl = self.movie?.posterPath {
            self.imgPoster.image(from: imgUrl)
            return
        }
         if let imgData = self.movie?.imagePoster {
            self.imgPoster.image = UIImage(data: imgData)
            return
        }
        self.imgPoster.image = UIImage(named:"placeholder")

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
