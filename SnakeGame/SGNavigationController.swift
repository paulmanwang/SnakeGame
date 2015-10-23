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
    
    override func shouldAutorotate() -> Bool {
        if (self.topViewController?.respondsToSelector("shouldAutorotate") != nil) {
            return (self.topViewController?.shouldAutorotate())!
        }
        
        return true
    }

}
