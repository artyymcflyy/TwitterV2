//
//  LoginViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/11/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com") , consumerKey: "tKkx1uJGfbhVrZA7JpQhJFDQh", consumerSecret: "UIq1Z2foJhlfRmV3kbFGebBs1vFhVYPOXW6XxCk4o6Mc41z7Xu")
        
        twitterClient?.deauthorize()

        twitterClient?.fetchRequestToken(withPath: "https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: URL(string: "cpTwittr://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I got a token!")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + requestToken!.token)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error!) in
            print("error: \(error.localizedDescription)")
        })
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
