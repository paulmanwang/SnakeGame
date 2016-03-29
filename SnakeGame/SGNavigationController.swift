//
//  SGNavigationController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/23.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class SGNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//        return UIInterfaceOrientation.LandscapeRight
//    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func shouldAutorotate() -> Bool {
//        if (self.topViewController?.respondsToSelector("shouldAutorotate") != nil) {
//            return (self.topViewController?.shouldAutorotate())!
//        }
        
        return true
    }
}
