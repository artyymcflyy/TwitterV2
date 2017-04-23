//
//  AppDelegate.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/11/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let containerViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerViewController
        
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuViewController
        
        window?.addSubview(containerViewController.view)
        
        if User.currentUser != nil{
            
            menuViewController.containerViewController = containerViewController
            containerViewController.menuViewController = menuViewController
            
            window?.rootViewController = containerViewController
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil, queue: OperationQueue.main) { (Notification) in
            
            self.window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object: nil, queue: OperationQueue.main) { (Notification) in
            
            let storyBoardProfile = UIStoryboard(name: "Profile", bundle: nil)
            let userNVC = storyBoardProfile.instantiateViewController(withIdentifier: "UserProfileNVC") as! UINavigationController
            
            let userVC = userNVC.topViewController as! UserProfileViewController
            
            let screen_name = Notification.object as! String
            TwitterClient.sharedInstance?.getUser(screen_name: screen_name, success: { (user:User) in
                userVC.user = user
                TwitterClient.sharedInstance?.getAnyUserProfileTimeline(screen_name: screen_name, success: { (userTweets:[Tweet]) in
                    
                    userVC.tweets = userTweets
                    containerViewController.contentViewController = userNVC
                    
                }, failure: { (error:Error) in
                    print("error: \(error.localizedDescription)")
                })
                
            }, failure: { (error:Error) in
                print("\(error.localizedDescription)")
            })
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "timeline"), object: nil, queue: OperationQueue.main) { (Notification) in
            
            let storyBoardProfile = UIStoryboard(name: "TweetStream", bundle: nil)
            let timelineNVC = storyBoardProfile.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
            
            let timelineVC = timelineNVC.topViewController as! HomeTimelineViewController
            
            let type = Notification.object as! String
            
            TwitterClient.sharedInstance?.getAuthenticatedUserTimeLine(typeOfTimeline: type, success: { (tweets:[Tweet]) in
                timelineVC.tweets = tweets
                timelineVC.typeOfTimeline = type
                containerViewController.contentViewController = timelineNVC
                
            }, failure: { (error:Error) in
                print("\(error.localizedDescription)")
            })
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        TwitterClient.sharedInstance?.handleOpenUrl(url: url)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuViewController
        let containerViewController = storyBoard.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerViewController
        
        window?.rootViewController?.present(containerViewController, animated: false, completion: nil)
        
        menuViewController.containerViewController = containerViewController
        containerViewController.menuViewController = menuViewController
        
        return true
    }


}

