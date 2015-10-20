//
//  RootViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/19.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var snakeButton: UIButton?
    var timer: NSTimer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "贪吃蛇";
        self.view.backgroundColor = UIColor.yellowColor()
        
        self.snakeButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
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
        let originRect = self.snakeButton!.frame
        self.snakeButton!.frame = CGRectMake(originRect.origin.x + 10, originRect.origin.y + 10, originRect.size.width, originRect.size.height)
    }
    
    // MARK: - Private
    
    func configureNavigationItem()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "排行", style: UIBarButtonItemStyle.Plain, target: self, action: "onRankButtonClicked:")
        
        let startButton = UIBarButtonItem(title: "开始", style: UIBarButtonItemStyle.Plain, target: self, action: "onStartGameButtonClicked:")
        let settingButton = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: "onSettingButtonClicked:")
        self.navigationItem.rightBarButtonItems = [settingButton, startButton]
    }
    
    // MARK - Button actions
    
    func onStartGameButtonClicked(sender: UIButton)
    {
        print("开始游戏")
        self.startTimer()
    }
    
    func onRankButtonClicked(sender: UIButton)
    {
        print("排行点击")
    }
    
    func onSettingButtonClicked(sender:UIButton)
    {
        print("设置点击")
    }
    
    // MARK - NSTimer
    
    func startTimer()
    {
        if self.timer == nil {
            //self.timer = NSTimer(timeInterval: 1, target: self, selector: "timeout:", userInfo: nil, repeats:true)
            // self.timer? = NSTimer(timeInterval: 1, target: self, selector: "timeout:", userInfo: nil, repeats:true) 这句代码timer返回nil
            //NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeout:", userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer()
    {
        if self.timer != nil {
            self.timer!.invalidate()
            self.timer = nil
        }
    }
    
    func timeout(timer:NSTimer)
    {
        print("定时器")
    }
}
