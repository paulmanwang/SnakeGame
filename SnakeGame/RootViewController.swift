//
//  RootViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/19.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    var mainBoard: MainBoard?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "贪吃蛇";
        self.view.backgroundColor = UIColor.yellowColor()
        self.configureNavigationItem()
        
        let width: CGFloat = UIScreen.mainScreen().bounds.width
        let height: CGFloat = UIScreen.mainScreen().bounds.height
        self.mainBoard = MainBoard(parent: self.view, width: width, height: height)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private
    
    func configureNavigationItem()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "排行", style: UIBarButtonItemStyle.Plain, target: self, action: "onRankButtonClicked:")
        
        let startButton = UIBarButtonItem(title: "开始", style: UIBarButtonItemStyle.Plain, target: self, action: "onStartGameButtonClicked:")
        let settingButton = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: "onSettingButtonClicked:")
        self.navigationItem.rightBarButtonItems = [settingButton, startButton]
    }
    
    // MARK: - Button actions
    
    func onStartGameButtonClicked(sender: UIButton)
    {
        print("开始游戏")
        self.mainBoard?.startGame()
    }
    
    func onRankButtonClicked(sender: UIButton)
    {
        print("排行点击")
    }
    
    func onSettingButtonClicked(sender:UIButton)
    {
        print("设置点击")
    }
    
    }
