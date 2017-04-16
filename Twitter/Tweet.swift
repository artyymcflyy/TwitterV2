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
    var currTimeStamp: String?
    var detailTimeStamp: String?
    var tweet_id: String?
    var retweetCount: Int = 0
    var favoritesCount: Int  = 0
    let currTime = Date()
    var minutes:Int = 0
    var hours: Int = 0
    var days: Int = 0
    var rawTime:Int = 0
    
    init(dictionary: NSDictionary){
        let user = dictionary["user"] as! NSDictionary
        
        name  = user["name"] as? String
        screenname = "@\(user["screen_name"] ?? "")"
        text = dictionary["text"] as? String
        let profileImageString = user["profile_image_url"] as? String
        if let profileImageString = profileImageString{
            profileImageUrl = URL(string: profileImageString)
        }
        tweet_id = dictionary["id_str"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (user["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            detailTimeStamp = DateFormatter.localizedString(from: timestamp!, dateStyle: .short, timeStyle: .short)
        }
        
        rawTime = Int(currTime.timeIntervalSince(timestamp!))
        minutes = rawTime/60
        hours = rawTime/3600
        days = rawTime/86400
        
        if rawTime < 60{
            currTimeStamp = "\(rawTime)s"
        }
        if rawTime >= 60{
            if rawTime < 3600{
               currTimeStamp = "\(minutes)m"
            }
        }
        if rawTime >= 3600{
            if rawTime < 86400{
                currTimeStamp = "\(hours)h"
            }
        }
        if rawTime >= 86400{
            currTimeStamp = timestamp?.description
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
