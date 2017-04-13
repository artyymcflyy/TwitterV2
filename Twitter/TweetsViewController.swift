//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/12/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
            self.tweets = tweets
            
            for tweet in tweets{
                print(tweet.text!)
            }
        }, failure: { (error:NSError) in
            
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
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
