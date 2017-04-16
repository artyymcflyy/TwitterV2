//
//  TweetDetailCell.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/13/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {
    
    @IBOutlet var favoriteButtonIcon: UIButton!
    @IBOutlet var retweetButtonIcon: UIButton!
    @IBOutlet var retweetedView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var favoritesLabel: UILabel!
    @IBOutlet var retweetsLabel: UILabel!
    @IBOutlet var timestamplabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    var retweetIsSelected = false
    var favoriteIsSelected = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getImageFromURL(url: URL){
        profileImageView.setImageWith(url)
    }

    @IBAction func replyButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func retweetButtonTapped(_ sender: UIButton) {
        let image1 = UIImage(named: "retweet-fill")
        let image2 = UIImage(named: "retweet")
        
        if !retweetIsSelected{
            retweetButtonIcon.setImage(image1, for: .normal)
            retweetIsSelected = true
        }else{
            retweetButtonIcon.setImage(image2, for: .normal)
            retweetIsSelected = false
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let image1 = UIImage(named: "star-fill")
        let image2 = UIImage(named: "star")
        
        if !favoriteIsSelected{
            favoriteButtonIcon.setImage(image1, for: .normal)
            favoriteIsSelected = true
        }else{
            favoriteButtonIcon.setImage(image2, for: .normal)
            favoriteIsSelected = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
