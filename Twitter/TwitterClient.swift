//
//  TwitterClient.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/12/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com") , consumerKey: "tKkx1uJGfbhVrZA7JpQhJFDQh", consumerSecret: "UIq1Z2foJhlfRmV3kbFGebBs1vFhVYPOXW6XxCk4o6Mc41z7Xu")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()->(), faliure: @escaping (Error)->()){
        loginSuccess = success
        loginFailure = faliure
        
        deauthorize()
        
        fetchRequestToken(withPath: "https://api.twitter.com/oauth/request_token", method: "GET", callbackURL: URL(string: "cpTwittr://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + requestToken!.token)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error!) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken,success: { (access_token:BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user:User) in
                
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error:Error) in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }, failure: { (error: Error!) in
            print("error \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    func homeTimeLine(success: @escaping ([Tweet])->(), failure: (NSError)->()){
        
        get("/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
//            print(response)
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsInArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print("error \(error.localizedDescription)")
            self.loginFailure?(error as NSError)
        })
    }
    
    func currentAccount(success:@escaping (User)->(), failure:@escaping (Error)->()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
//            print(user.name as Any)
//            print(user.screenName)
//            print(user.profileUrl)
//            print(user.tagLine)
            success(user)
            
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            failure(error)
        })
    }
}
