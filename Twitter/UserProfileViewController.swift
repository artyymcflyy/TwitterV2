//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/20/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var userProfileInfoView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userProfileBannerImageView: UIImageView!
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userScreenNameLabel: UILabel!
    @IBOutlet var numberOfTweets: UILabel!
    @IBOutlet var numberOfFollowing: UILabel!
    @IBOutlet var numberOfFollowers: UILabel!
    
    var tweets: [Tweet]!
    var savedScreenName = ""
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
       // userProfileInfoView.removeFromSuperview()
        
        tableView.register(UINib(nibName: "UserProfileView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        if let url = user?.profileUrl{
            userProfileImageView.setImageWith(url)
        }
        
        if let bannerUrl = user?.profileBannerUrl{
            userProfileBannerImageView.setImageWith(bannerUrl)
        }
        userNameLabel.text = user?.name
        userScreenNameLabel.text = user?.screenName
        numberOfTweets.text = "\(user?.totalTweets ?? 0)"
        numberOfFollowers.text = "\(user?.followers ?? 0)"
        numberOfFollowing.text = "\(user?.following ?? 0)"
        
    }
    
    func refreshAction(_ refreshControl: UIRefreshControl){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object:savedScreenName)
    }
    
    @IBAction func onSignOutTapped(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    
    @IBAction func onNewTweetTap(_ sender: UIBarButtonItem) {
        let timelineStoryboard = UIStoryboard(name: "Timeline", bundle: nil)
        let newTweetVC = timelineStoryboard.instantiateViewController(withIdentifier: "NewTweetVC")
        
        present(newTweetVC, animated: true, completion: nil)
    }
    
    func didTapUserProfileImage(_ sender: UITapGestureRecognizer) {
        let screen_name = tweets[(sender.view?.tag)!].retweetedUsername == nil ? tweets[(sender.view?.tag)!].screenname! : tweets[(sender.view?.tag)!].retweetedUsername!
        savedScreenName = screen_name
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object: screen_name)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return tweets.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfileImage(_:)))
        
        if cell.tweetLabel.text?.range(of: "RT") == nil{
            cell.topRetweetedViewConstraint.constant = -20
            cell.topProfileImageConstraint.constant = 20
            
            if tweet.profileImageUrl != nil{
                cell.getImageFromURL(url: tweet.profileImageUrl!)
                cell.profileImageView.addGestureRecognizer(tapGesture)
                cell.profileImageView.isUserInteractionEnabled = true
                cell.profileImageView.tag = indexPath.row
            }
            
        }else{
            cell.topRetweetedViewConstraint.constant = 3.5
            cell.topProfileImageConstraint.constant = 32
            
            if tweet.screenname == User.currentUser?.screenName{
                cell.retweetButton.setImage(UIImage(named: "retweet-fill") , for: .normal)
                cell.retweetCountLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
                cell.retweetCountLabel.textColor = UIColor.black
            }
            
            if tweet.isFavorited!{
                cell.favoriteButton.setImage(UIImage(named: "star-fill") , for: .normal)
                cell.favoriteCountLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
                cell.favoriteCountLabel.textColor = UIColor.black
            }
            
            cell.retweetedUsernameLabel.text = tweet.name! + " retweeted"
            cell.tweetLabel.text = tweet.retweetedText
            cell.nameLabel.text = tweet.retweetedName
            cell.usernameLabel.text = tweet.retweetedUsername
            cell.retweetCountLabel.text = "\(tweet.retweetingUserRetweets)"
            cell.favoriteCountLabel.text = "\(tweet.retweetingUserFavorites)"
            
            if tweet.retweetedProfileUrl != nil{
                cell.getImageFromURL(url: tweet.retweetedProfileUrl!)
                cell.profileImageView.addGestureRecognizer(tapGesture)
                cell.profileImageView.isUserInteractionEnabled = true
                cell.profileImageView.tag = indexPath.row
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        
        header?.backgroundColor = .blue
        
        return header
        
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
