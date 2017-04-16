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
        cell.retweetedView.removeFromSuperview()
        
        cell.nameLabel.text = tweet?.name
        cell.usernameLabel.text = tweet?.screenname
        if tweet?.profileImageUrl != nil{
            cell.getImageFromURL(url: (tweet?.profileImageUrl)!)
        }
        cell.tweetLabel.text = tweet?.text
        cell.timestamplabel.text = tweet?.detailTimeStamp
        let retweetInt = tweet?.retweetCount ?? 0
        let favoritesInt = tweet?.favoritesCount ?? 0
        cell.retweetsLabel.text = "\(retweetInt)"
        cell.favoritesLabel.text = "\(favoritesInt)"
        
        return cell
    }
    
    @IBAction func retweetButtonTapped(_ sender: UIButton) {
        let image1 = UIImage(named: "retweet-fill")
        let image2 = UIImage(named: "retweet")
        
        TwitterClient.sharedInstance?.retweetTweet(isCurrentlyRetweeted: retweetIsSelected, tweetID: (tweet?.tweet_id)!, success: { (isRetweeted:Bool) in
            
            self.retweetIsSelected = isRetweeted
            if self.retweetIsSelected{
                
                self.tweet?.retweetCount += 1
                self.retweetButtonIcon.setImage(image1, for: .normal)
                
            }else{
                
                self.tweet?.retweetCount -= 1
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
        
        TwitterClient.sharedInstance?.favoritedTweet(isCurrentlyFavorited: favoriteIsSelected, tweetID: (tweet?.tweet_id)!, success: { (isFavorited:Bool) in
            
            self.favoriteIsSelected = isFavorited
            
            if self.favoriteIsSelected{
                
                self.tweet?.favoritesCount += 1
                self.favoriteButtonIcon.setImage(image1, for: .normal)
                
            }else{
                
                self.tweet?.favoritesCount -= 1
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
