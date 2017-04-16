//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/15/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    @objc optional func newTweetViewController(NewTweetViewController:NewTweetViewController, didGetValue value: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var characterCount: UILabel!
    @IBOutlet var tweetTextArea: UITextView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userProfileImageView: UIImageView!
    var count = 0
    var tweetText = ""
    var delegate: NewTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextArea.delegate = self
        
        nameLabel.text = User.currentUser?.name
        usernameLabel.text = User.currentUser?.screenName
        
        if User.currentUser?.profileUrl != nil{
            userProfileImageView.setImageWith((User.currentUser?.profileUrl)!)
        }
        tweetTextArea.text = ""
        
        tweetTextArea.becomeFirstResponder()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        count = textView.text.characters.count
        if count <= 140{
            let labelCount = 140-count
            characterCount.text = "\(labelCount)"
            tweetText = textView.text.substring(to: textView.text.endIndex)
        }else{
            textView.text = tweetText
        }
    }
    
    @IBAction func tweetButtonTapped(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.updateStatus(status: tweetText, replyID: "", success: { (myTweet:Tweet) in
            self.dismiss(animated: true, completion: { 
                self.delegate?.newTweetViewController!(NewTweetViewController: self, didGetValue: myTweet)
            })
        }, failure: { (error:Error) in
            print("\(error.localizedDescription)")
        })
    }
    
    @IBAction func onCancelTap(_ sender: UIBarButtonItem) {
       dismiss(animated: true, completion: nil)
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
