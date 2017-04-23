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
    var generalTimeStamp: String?
    var detailTimeStamp: String?
    var tweet_id: String?
    var retweet_id: String?
    var retweetCount: Int = 0
    var favoritesCount: Int  = 0
    var isRetweeted: Bool?
    var retweetedStatusInResponse: NSDictionary?
    var retweetedText: String?
    var retweetedUsername: String?
    var retweetedName: String?
    var retweetedProfileUrl: URL?
    var retweetingUserRetweets: Int = 0
    var retweetingUserFavorites: Int = 0
    var retweetingUserRetweetCount: Int = 0
    
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
        isRetweeted = dictionary["retweeted"] as? Bool
        retweetedStatusInResponse = dictionary["retweeted_status"] as? NSDictionary
        if retweetedStatusInResponse != nil{
            retweetedText = retweetedStatusInResponse?["text"] as? String
            retweetingUserRetweets = retweetedStatusInResponse?["retweet_count"] as? Int ?? 0
            retweetingUserFavorites = retweetedStatusInResponse?["favorite_count"] as? Int ?? 0
            retweet_id = retweetedStatusInResponse?["id_str"] as? String

            let retweetedFromUser = retweetedStatusInResponse?["user"] as? NSDictionary
            retweetedUsername = "@\(retweetedFromUser?["screen_name"] as? String ?? "")"
            retweetedName = retweetedFromUser?["name"] as? String
            retweetedProfileUrl = retweetedFromUser?["profile_image_url"] as? URL
            
        }
        
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        //let isFavorited = dictionary["favorited"] as? Bool
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            detailTimeStamp = DateFormatter.localizedString(from: timestamp!, dateStyle: .short, timeStyle: .short)
        }
        
        let currTime = Date()
        
        let rawTime = Int(currTime.timeIntervalSince(timestamp!))
        let minutes = rawTime/60
        let hours = rawTime/3600
        
        if rawTime < 60{
            generalTimeStamp = "\(rawTime)s"
        }
        if rawTime >= 60{
            if rawTime < 3600{
               generalTimeStamp = "\(minutes)m"
            }
        }
        if rawTime >= 3600{
            if rawTime < 86400{
                generalTimeStamp = "\(hours)h"
            }
        }
        if rawTime >= 86400{
            generalTimeStamp = timestamp?.description
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
