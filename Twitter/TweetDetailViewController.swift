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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailCell") as! TweetDetailCell
        cell.retweetedView.removeFromSuperview()
        
        cell.nameLabel.text = tweet?.name
        cell.usernameLabel.text = tweet?.screenname
        if tweet?.profileImageUrl != nil{
            cell.getImageFromURL(url: (tweet?.profileImageUrl)!)
        }
        cell.tweetLabel.text = tweet?.text
//        
//        let retweetInt = tweet?.retweetCount ?? 0
//        let favoritesInt = tweet?.favoritesCount ?? 0
//        cell.retweetsLabel.text = "\(retweetInt)"
//        cell.favoritesLabel.text = "\(favoritesInt)"
        
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
