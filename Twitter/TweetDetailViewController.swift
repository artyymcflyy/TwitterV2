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
