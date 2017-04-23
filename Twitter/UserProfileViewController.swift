//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/20/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var tweets: [Tweet]!
    var savedScreenName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
    }
    
    func refreshAction(_ refreshControl: UIRefreshControl){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object:savedScreenName)
    }
    
    @IBAction func onNewTweetTap(_ sender: UIBarButtonItem) {
        let timelineStoryboard = UIStoryboard(name: "Timeline", bundle: nil)
        let newTweetVC = timelineStoryboard.instantiateViewController(withIdentifier: "NewTweetVC")
        
        present(newTweetVC, animated: true, completion: nil)
    }
    
    func didTapUserProfileImage(_ sender: UITapGestureRecognizer) {
        let screen_name = tweets[(sender.view?.tag)!].retweetedUsername == nil ? tweets[(sender.view?.tag)!].screenname! : tweets[(sender.view?.tag)!].retweetedUsername!
        savedScreenName = screen_name
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object: ["screen_name": screen_name])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return tweets.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell

        let tweet = tweets[indexPath.row]
        
        cell.nameLabel.text = tweet.name
        cell.usernameLabel.text = tweet.screenname
        cell.tweetLabel.text = tweet.text
        cell.timestampLabel.text = tweet.generalTimeStamp
        cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
        
        if cell.tweetLabel.text?.range(of: "RT") == nil{
            cell.topRetweetedViewConstraint.constant = -20
            cell.topProfileImageConstraint.constant = 20
            
        }else{
            cell.topRetweetedViewConstraint.constant = 3.5
            cell.topProfileImageConstraint.constant = 32
            
            cell.retweetedUsernameLabel.text = tweet.name! + " retweeted"
            cell.tweetLabel.text = tweet.retweetedText
            cell.nameLabel.text = tweet.retweetedName
            cell.usernameLabel.text = tweet.retweetedUsername
            cell.retweetCountLabel.text = "\(tweet.retweetingUserRetweets)"
            cell.favoriteCountLabel.text = "\(tweet.retweetingUserFavorites)"
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfileImage(_:)))
        
        if tweet.profileImageUrl != nil{
            cell.getImageFromURL(url: tweet.profileImageUrl!)
            cell.profileImageView.addGestureRecognizer(tapGesture)
            cell.profileImageView.isUserInteractionEnabled = true
            cell.profileImageView.tag = indexPath.row
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
