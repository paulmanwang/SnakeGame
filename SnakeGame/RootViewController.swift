//
//  RootViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/19.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, GameBoardDelegate {
    
    var topGameBoard: GameBoard?
    var bottomGameBoard: GameBoard?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "简易贪吃蛇"
        self.configureNavigationItem()
    }
    
    func drawGameBoards() {
        let width: CGFloat = UIScreen.mainScreen().bounds.width
        let height: CGFloat = UIScreen.mainScreen().bounds.height - 66
        
        self.topGameBoard = GameBoard(frame: CGRectMake(0, 0, width, height/2))
        self.topGameBoard?.backgroundColor = UIColor.blueColor()
        self.topGameBoard?.drawSanke()
        //self.topGameBoard?.delegate = self
        self.view.addSubview(self.topGameBoard!);
        
        self.bottomGameBoard = GameBoard(frame: CGRectMake(0, height/2, width, height/2))
        self.bottomGameBoard?.backgroundColor = UIColor.blackColor()
        self.bottomGameBoard?.drawSanke()
        //self.bottomGameBoard?.delegate = self
        self.view.addSubview(self.bottomGameBoard!);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.drawGameBoards();
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return self.topGameBoard?.gameState == GameState.GameIsReady
    }

    // MARK: - Private
    
    func configureNavigationItem()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "得分：0", style: UIBarButtonItemStyle.Plain, target: self, action: "onRankButtonClicked:")
        
        let startButton = UIBarButtonItem(title: "开始", style: UIBarButtonItemStyle.Plain, target: self, action: "onStartGameButtonClicked:")
        let settingButton = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: "onSettingButtonClicked:")
        self.navigationItem.rightBarButtonItems = [settingButton, startButton]
    }
    
    // MARK: - Button actions
    
    func onStartGameButtonClicked(sender: UIButton)
    {
        self.topGameBoard?.startGame()
        self.bottomGameBoard?.startGame()
        return
        
        let startButton = self.navigationItem.rightBarButtonItems![1] as? UIBarButtonItem
        if self.topGameBoard?.gameState == GameState.GameIsReady
            || self.topGameBoard?.gameState == GameState.GameIsPaused {
            startButton?.title = "暂停"
            let width: CGFloat = UIScreen.mainScreen().bounds.width
            var height: CGFloat = UIScreen.mainScreen().bounds.height - 66
            if self.view.frame.width > self.view.frame.height {
                height -= 32
            } else {
                height -= 66
            }
            self.topGameBoard?.startGame()
        } else if self.topGameBoard?.gameState == GameState.GameIsPlaying { // 暂停游戏
            startButton?.title = "开始"
            self.topGameBoard?.pauseGame()
        }
    }
    
    func onRankButtonClicked(sender: UIButton)
    {
        print("排行点击")
        let controller = RankViewController(nibName:"RankViewController", bundle:nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onSettingButtonClicked(sender:UIButton) {
        print("设置点击")
        let controller = RankViewController(nibName:"SettingViewController", bundle:nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - MainBoardDelegate
    
    func gameScoreChanged(score: Int) {
        print("score = \(score)")
        self.navigationItem.leftBarButtonItem?.title = "得分：\(score)"
    }
    
    func gameOver() {
        let startButton = self.navigationItem.rightBarButtonItems![1] as? UIBarButtonItem
        startButton?.title = "开始"
        self.navigationItem.leftBarButtonItem?.title = "得分：0"
    }
}
