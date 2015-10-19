//
//  RootViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/19.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var snakeButton:UIButton?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "贪吃蛇";
        self.view.backgroundColor = UIColor.yellowColor()
        
        self.snakeButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
        self.snakeButton!.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.snakeButton!)
        
        self.configureNavigationItem()
        
        // 添加手势
        let swapGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        self.view.addGestureRecognizer(swapGesture)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - GestureRecognizer
    
    func handleSwapGesture(gestureRecongizer:UIGestureRecognizer)
    {
        print("滑动手势");
        let originRect = self.snakeButton!.frame;
        self.snakeButton!.frame = CGRectMake(originRect.origin.x + 10, originRect.origin.y + 10, originRect.size.width, originRect.size.height);
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
