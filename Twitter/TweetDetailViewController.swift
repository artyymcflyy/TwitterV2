//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/13/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favoriteButtonIcon: UIButton!
    @IBOutlet var retweetButtonIcon: UIButton!
    
    var retweetIsSelected = false
    var favoriteIsSelected = false
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailCell") as! TweetDetailCell
        //cell.retweetedView.removeFromSuperview()
        
        cell.nameLabel.text = tweet?.name
        cell.usernameLabel.text = tweet?.screenname
        cell.tweetLabel.text = tweet?.text
        cell.retweetsLabel.text = "\(tweet?.retweetCount ?? 0)"
        cell.favoritesLabel.text = "\(tweet?.favoritesCount ?? 0)"
        cell.timestamplabel.text = tweet?.detailTimeStamp
        
        if cell.tweetLabel.text?.range(of: "RT") == nil{
            cell.retweetedUserNameLabel.removeFromSuperview()
            cell.retweetedImageView.removeFromSuperview()
            
        }else{
            cell.contentView.addSubview(cell.retweetedImageView)
            cell.contentView.addSubview(cell.retweetedUserNameLabel)
            
            let horizonalContraints = NSLayoutConstraint(item: cell.retweetedImageView, attribute:
                .leadingMargin, relatedBy: .equal, toItem: cell.contentView,
                                attribute: .leadingMargin, multiplier: 1.0,
                                constant: 44)
            
            let topContraints = NSLayoutConstraint(item: cell.retweetedImageView, attribute:
                .top, relatedBy: .equal, toItem: cell.contentView,
                      attribute: .top, multiplier: 1.0, constant: 2)
            
            let horizontal3Contraints = NSLayoutConstraint(item: cell.retweetedImageView, attribute:
                .trailingMargin, relatedBy: .equal, toItem: cell.retweetedUserNameLabel,
                                 attribute: .leadingMargin, multiplier: 1.0,
                                 constant: -20)
            
            let alignContraints = NSLayoutConstraint(item: cell.retweetedUserNameLabel, attribute:
                .centerY, relatedBy: .equal, toItem: cell.retweetedImageView,
                          attribute: .centerY, multiplier: 1.0, constant: 0)
            
            let horizontal2Contraints = NSLayoutConstraint(item: cell.retweetedUserNameLabel, attribute:
                .leadingMargin, relatedBy: .equal, toItem: cell.retweetedImageView,
                                attribute: .trailingMargin, multiplier: 1.0,
                                constant: 5)
            
            let horizontal4Contraints = NSLayoutConstraint(item: cell.retweetedUserNameLabel, attribute:
                .trailingMargin, relatedBy: .lessThanOrEqual, toItem: cell.contentView,
                                 attribute: .trailingMargin, multiplier: 1.0, constant: -100)
            
            cell.retweetedImageView.frame.size.width = 21
            cell.retweetedImageView.frame.size.height = 22
            
            
            cell.retweetedImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.retweetedUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([horizonalContraints, topContraints,horizontal2Contraints,horizontal3Contraints, horizontal4Contraints, alignContraints])
            
            cell.retweetedUserNameLabel.text = (tweet?.name!)! + " retweeted"
            cell.tweetLabel.text = tweet?.retweetedText
            cell.nameLabel.text = tweet?.retweetedName
            cell.usernameLabel.text = tweet?.retweetedUsername
            cell.retweetsLabel.text = "\(tweet?.retweetedRetweets ?? 0)"
            cell.favoritesLabel.text = "\(tweet?.retweetedFavorites ?? 0)"
        }
        if tweet?.profileImageUrl != nil{
            cell.getImageFromURL(url: (tweet?.profileImageUrl!)!)
        }
        
//        cell.retweetedView.removeFromSuperview()
//        
//        cell.nameLabel.text = tweet?.name
//        cell.usernameLabel.text = tweet?.screenname
//        if tweet?.profileImageUrl != nil{
//            cell.getImageFromURL(url: (tweet?.profileImageUrl)!)
//        }
//        cell.tweetLabel.text = tweet?.text
//        cell.timestamplabel.text = tweet?.detailTimeStamp
//        let retweetInt = tweet?.retweetCount ?? 0
//        let favoritesInt = tweet?.favoritesCount ?? 0
//        cell.retweetsLabel.text = "\(retweetInt)"
//        cell.favoritesLabel.text = "\(favoritesInt)"
        
        return cell
    }
    
    @IBAction func retweetButtonTapped(_ sender: UIButton) {
        let image1 = UIImage(named: "retweet-fill")
        let image2 = UIImage(named: "retweet")
        
        let id = tweet?.retweet_id != nil ? (tweet?.retweet_id)! : (tweet?.tweet_id)!
        
        TwitterClient.sharedInstance?.retweetTweet(isCurrentlyRetweeted: retweetIsSelected, tweetID: id, success: { (isRetweeted:Bool) in
            
            self.retweetIsSelected = isRetweeted
            if self.retweetIsSelected{
                if self.tweet?.retweet_id != nil{
                    self.tweet?.retweetedRetweetCount += 1
                }else{
                    self.tweet?.retweetCount += 1
                }
                self.retweetButtonIcon.setImage(image1, for: .normal)
                
            }else{
                
                if self.tweet?.retweet_id != nil{
                    self.tweet?.retweetedRetweetCount -= 1
                }else{
                    self.tweet?.retweetCount -= 1
                }
                self.retweetButtonIcon.setImage(image2, for: .normal)
                
            }
            
            self.tableView.reloadData()
            
        }, failure: { (error:Error) in
                print("error \(error.localizedDescription)")
        })
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let image1 = UIImage(named: "star-fill")
        let image2 = UIImage(named: "star")
        
        let id = tweet?.retweet_id != nil ? (tweet?.retweet_id)! : (tweet?.tweet_id)!
            
        TwitterClient.sharedInstance?.favoritedTweet(isCurrentlyFavorited: favoriteIsSelected, tweetID: id, success: { (isFavorited:Bool) in
            
            self.favoriteIsSelected = isFavorited
            
            if self.favoriteIsSelected{
                if self.tweet?.retweet_id != nil{
                    self.tweet?.retweetedFavoritesCount += 1
                }else{
                    self.tweet?.favoritesCount += 1
                }
                self.favoriteButtonIcon.setImage(image1, for: .normal)
                
            }else{
                
                if self.tweet?.retweet_id != nil{
                    self.tweet?.retweetedFavoritesCount -= 1
                }else{
                    self.tweet?.favoritesCount -= 1
                }
                self.favoriteButtonIcon.setImage(image2, for: .normal)
                
            }
            
            self.tableView.reloadData()
                
        }, failure: { (error:Error) in
            print("error \(error.localizedDescription)")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replyTweetModal"{
            
            let ntvc = segue.destination as! NewTweetViewController
            
            if tweet?.screenname != nil{
                
                let username = (tweet?.screenname)!
                ntvc.tweetText = "\(username) "
                
            }
            
            if tweet?.tweet_id != nil{
                
                ntvc.replyID = (tweet?.tweet_id)!
                
            }
        }
    }

}
