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
    
    func didTapUserProfileImage(_ sender: UITapGestureRecognizer) {
        let screen_name = tweet?.retweetedUsername == nil ? tweet?.screenname! : tweet?.retweetedUsername!
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object: screen_name)
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
            cell.topRetweetedViewConstraint.constant = -20
            cell.topProfileImageConstraint.constant = 20
            
        }else{
            cell.topRetweetedViewConstraint.constant = 3.5
            cell.topProfileImageConstraint.constant = 32
            
            cell.retweetedUserNameLabel.text = (tweet?.name!)! + " retweeted"
            cell.tweetLabel.text = tweet?.retweetedText
            cell.nameLabel.text = tweet?.retweetedName
            cell.usernameLabel.text = tweet?.retweetedUsername
            cell.retweetsLabel.text = "\(tweet?.retweetingUserRetweets ?? 0)"
            cell.favoritesLabel.text = "\(tweet?.retweetingUserFavorites ?? 0)"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfileImage(_:)))
        
        if tweet?.profileImageUrl != nil{
            cell.getImageFromURL(url: (tweet?.profileImageUrl!)!)
            
            cell.profileImageView.addGestureRecognizer(tapGesture)
            cell.profileImageView.isUserInteractionEnabled = true
            cell.profileImageView.tag = indexPath.row
        }
        
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
                    self.tweet?.retweetingUserRetweets += 1
                }else{
                    self.tweet?.retweetCount += 1
                }
                self.retweetButtonIcon.setImage(image1, for: .normal)
                
            }else{
                
                if self.tweet?.retweet_id != nil{
                    self.tweet?.retweetingUserRetweets -= 1
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
                    self.tweet?.retweetingUserFavorites += 1
                }else{
                    self.tweet?.favoritesCount += 1
                }
                self.favoriteButtonIcon.setImage(image1, for: .normal)
                
            }else{
                
                if self.tweet?.retweet_id != nil{
                    self.tweet?.retweetingUserFavorites -= 1
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
    
    @IBAction func didTapUserProfileImageInDetailView(_ sender: UITapGestureRecognizer) {
        print("hello")
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
                let username = tweet?.retweetedUsername != nil ? tweet?.retweetedUsername : tweet?.screenname
                ntvc.tweetText = "\(username ?? "") "
                
            }
            
            if tweet?.tweet_id != nil{
                
                ntvc.replyID = (tweet?.tweet_id)!
                
            }
        }
    }

}
