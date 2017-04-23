//
//  TweetCell.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/13/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet var topRetweetedViewConstraint: NSLayoutConstraint!
    @IBOutlet var topProfileImageConstraint: NSLayoutConstraint!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var retweetedUsernameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getImageFromURL(url: URL){
//        profileImageView.image = UIImage()
        profileImageView.setImageWith(url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
