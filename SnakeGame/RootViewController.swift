//
//  RootViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/19.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "贪吃蛇";
        self.view.backgroundColor = UIColor.yellowColor()
        
        let button: UIButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
        button.backgroundColor = UIColor.redColor()
        self.view.addSubview(button)
        
        self.configureNavigationItem()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private
    
    func configureNavigationItem()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "排行", style: UIBarButtonItemStyle.Plain, target: self, action: "onRankButtonClicked:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "排行", style: UIBarButtonItemStyle.Plain, target: self, action: "onSettingButtonClicked:")
    }
    
    // MARK - Button actions
    
    func onRankButtonClicked(sender: UIButton)
    {
        print("排行点击")
    }
    
    func onSettingButtonClicked(sender:UIButton)
    {
        print("设置点击")
    }
    
}
