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
    var tweetTimelineCount = 20
    
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
    
    func updateStatus(status: String, replyID: String, success:@escaping (Tweet)->(), failure: (Error)->()){
        post("/1.1/statuses/update.json", parameters: ["status": status, "in_reply_to_status_id": replyID], progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
            
        }, failure:{ (task:URLSessionDataTask?, error:Error) in
            print("error \(error.localizedDescription)")
        })
    }
    
    func homeTimeLine(success: @escaping ([Tweet])->(), failure: (Error)->()){
        
        get("/1.1/statuses/home_timeline.json", parameters: ["count":"\(tweetTimelineCount)"], progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsInArray(dictionaries: dictionaries)
            self.tweetTimelineCount += 20
            
            success(tweets)
            
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            print("error \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    func favoritedTweet(isCurrentlyFavorited: Bool, tweetID: String,success:@escaping (Bool)->(), failure:(Error)->()){
        let resource = isCurrentlyFavorited ? "destroy" : "create"
        
        post("/1.1/favorites/"+resource+".json", parameters: ["id":tweetID], progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let dictionary = response as! NSDictionary
            let favorited = dictionary["favorited"] as! Bool
            
            success(favorited)
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print("error \(error.localizedDescription )")
        }
    }
    
    func retweetTweet(isCurrentlyRetweeted: Bool, tweetID: String,success:@escaping (Bool)->(), failure:(Error)->()){
        let resource = isCurrentlyRetweeted ? "unretweet" : "retweet"
        post("/1.1/statuses/"+resource+"/"+tweetID+".json", parameters: ["id":tweetID], progress: nil, success: { (task:URLSessionDataTask, response:Any?) in
            let dictionary = response as! NSDictionary
            var retweeted = dictionary["retweeted"] as! Bool
            
            if dictionary["retweeted_status"] == nil{
                retweeted = false
            }
            success(retweeted)
            
        }) { (task:URLSessionDataTask?, error:Error) in
            print("error \(error.localizedDescription )")
        }
    }
    
    func currentAccount(success:@escaping (User)->(), failure:@escaping (Error)->()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task:URLSessionDataTask?, error:Error) in
            failure(error)
        })
    }
}
