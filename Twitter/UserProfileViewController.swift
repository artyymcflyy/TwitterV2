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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onNewTweetTap(_ sender: UIBarButtonItem) {
        let timelineStoryboard = UIStoryboard(name: "Timeline", bundle: nil)
        let newTweetVC = timelineStoryboard.instantiateViewController(withIdentifier: "NewTweetVC")
        
        present(newTweetVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
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
        
        if tweet.profileImageUrl != nil{
            cell.getImageFromURL(url: tweet.profileImageUrl!)
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
