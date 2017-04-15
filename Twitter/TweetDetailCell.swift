//
//  TweetDetailCell.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/13/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {
    
    @IBOutlet var retweetedView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var favoritesLabel: UILabel!
    @IBOutlet var retweetsLabel: UILabel!
    @IBOutlet var timestamplabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getImageFromURL(url: URL){
        profileImageView.setImageWith(url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
