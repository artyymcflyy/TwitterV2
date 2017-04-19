//
//  ContainerViewController.swift
//  Twitter
//
//  Created by Arthur Burgin on 4/19/17.
//  Copyright © 2017 Arthur Burgin. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var leadingLayoutConstraint: NSLayoutConstraint!
    
    var originalLayoutConstraintVal: CGFloat!
    
    var menuViewController: UIViewController!{
        didSet{
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController!{
        didSet(oldContentViewController){
            view.layoutIfNeeded()
            if (oldContentViewController != nil){
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            
            contentView.addSubview(contentViewController.view)
            
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3) {
                self.leadingLayoutConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case .began:
            originalLayoutConstraintVal = leadingLayoutConstraint.constant
        case .changed:
            if velocity.x < 0{
                leadingLayoutConstraint.constant = 0
            }else{
                leadingLayoutConstraint.constant = originalLayoutConstraintVal + translation.x
            }
        case .ended:
            if velocity.x > 0{
                leadingLayoutConstraint.constant = self.view.frame.width - 50
            }else{
                leadingLayoutConstraint.constant = 0
            }
        default:
            print("")
        }
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
