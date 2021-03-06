//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/12/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewTweetViewControllerDelegate, UIScrollViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    var indexOfImage = 0
    var typeOfTimeline = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ntd = NewTweetViewController()
        ntd.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        if typeOfTimeline == ""{
            typeOfTimeline = "home"
        }
        
        if User.currentUser != nil{
            TwitterClient.sharedInstance?.getAuthenticatedUserTimeLine(typeOfTimeline: typeOfTimeline, success: { (tweets:[Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
            }, failure: { (error:Error) in})
        }
    }
    
    func refreshAction(_ refreshControl: UIRefreshControl){
        TwitterClient.sharedInstance?.getAuthenticatedUserTimeLine(typeOfTimeline: typeOfTimeline, success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error:Error) in
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                TwitterClient.sharedInstance?.getAuthenticatedUserTimeLine(typeOfTimeline: typeOfTimeline, success: { (tweets:[Tweet]) in
                    self.tweets = tweets
                    self.isMoreDataLoading = false
                    self.tableView.reloadData()
                }, failure: { (error:Error) in
                })
            }
        }
        
    }
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func didTapUserProfileImage(_ sender: UITapGestureRecognizer, screen_name: String) {

        let screen_name = tweets[(sender.view?.tag)!].retweetedUsername == nil ? tweets[(sender.view?.tag)!].screenname! : tweets[(sender.view?.tag)!].retweetedUsername!
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfileImage(_: screen_name:)))
        
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
            
            if tweet.isRetweeted!{
                print("retweeted")
                cell.retweetButton.setImage(UIImage(named: "retweet-fill") , for: .normal)
                cell.retweetCountLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
                cell.retweetCountLabel.textColor = UIColor.black
            }
            
            if tweet.isFavorited!{
                print("favortied")
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
    
    func newTweetViewController(NewTweetViewController: NewTweetViewController, didGetValue value: Tweet) {
        tweets.insert(value, at: 0)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTweetModal"{
            let ntvc = segue.destination as! NewTweetViewController
            ntvc.delegate = self
        }
        if segue.identifier == "TweetDetail"{
            let vc = segue.destination as! TweetDetailViewController
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            
            vc.tweet = tweets[(indexPath?.row)!]
            
        }
        
    }

}
