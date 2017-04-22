//
//  MenuViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/19/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var containerViewController: ContainerViewController!
    
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let timelineStoryboard = UIStoryboard(name: "TweetStream", bundle: nil)
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let homeTimelimeNVC = timelineStoryboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        let userProfileNVC = profileStoryboard.instantiateViewController(withIdentifier: "UserProfileNVC")
        
        viewControllers.append(userProfileNVC)
        viewControllers.append(homeTimelimeNVC)
        viewControllers.append(homeTimelimeNVC)
        viewControllers.append(homeTimelimeNVC)
        
        containerViewController.contentViewController = homeTimelimeNVC
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.userScreenNameNotification), object: nil, queue: OperationQueue.main) { (Notification) in
            
            self.containerViewController.contentViewController = self.viewControllers[0]
            
            let val = Notification.object as! NSDictionary
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object: val["screen_name"])
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.fetchUserProfileNotification), object: User.currentUser?.screenName)
        }
        
        containerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        
        let titles = ["Profile", "Timeline", "Mentions", "Accounts"]
        cell.menuItemLabel.text = titles[indexPath.row]
        
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
