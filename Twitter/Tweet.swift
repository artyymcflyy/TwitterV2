//
//  Tweet.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/12/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var name: String?
    var screenname: String?
    var profileImageUrl: URL?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int  = 0
    
    init(dictionary: NSDictionary){
        let user = dictionary["user"] as! NSDictionary
        
        name  = user["name"] as? String
        screenname = "@\(user["screen_name"] ?? "")"
        text = dictionary["text"] as? String
        let profileImageString = user["profile_image_url"] as? String
        if let profileImageString = profileImageString{
            profileImageUrl = URL(string: profileImageString)
        }
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
    }
    
    //tweet helper
    class func tweetsInArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    

}
