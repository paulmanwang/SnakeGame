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
        self.title = "简易贪吃蛇";
        self.view.backgroundColor = UIColor.yellowColor()
        self.configureNavigationItem()
        
        let width: CGFloat = UIScreen.mainScreen().bounds.width
        let height: CGFloat = UIScreen.mainScreen().bounds.height - 66
        self.mainBoard = MainBoard(parent: self.view, width: width, height: height)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return self.mainBoard?.isGamePlaying == false
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
        if self.mainBoard?.isGamePlaying == false {
            print("开始游戏")
            let width: CGFloat = UIScreen.mainScreen().bounds.width
            let height: CGFloat = UIScreen.mainScreen().bounds.height - 66
            self.mainBoard?.setSize(width: width, height: height)
            self.mainBoard?.startGame()
        }
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
