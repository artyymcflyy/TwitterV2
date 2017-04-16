//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/12/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewTweetViewControllerDelegate, UIScrollViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    
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
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error:Error) in})
        
    }
    
    func refreshAction(_ refreshControl: UIRefreshControl){
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
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
                
                TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return tweets.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifiezr: "TweetDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.retweetedView.removeFromSuperview()
        let tweet = tweets[indexPath.row]
        
        cell.nameLabel.text = tweet.name
        cell.usernameLabel.text = tweet.screenname
        cell.tweetLabel.text = tweet.text
        cell.timestampLabel.text = tweet.currTimeStamp
        
        if tweet.profileImageUrl != nil{
            cell.getImageFromURL(url: tweet.profileImageUrl!)
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
