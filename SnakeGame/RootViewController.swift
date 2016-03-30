//
//  RootViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/19.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit
import GameKit

let LeaderBoardID: String  = "SnakeGameRank001"
let SnakeBlobSize: CGFloat = 20.0
let SnakeInitLength: Int   = 4
let BorderColor: UIColor = UIColor.whiteColor()
let SnakeColor: UIColor = UIColor(red: 65.0/255, green: 105.0/255, blue: 225.0/255, alpha: 1)
let FoodColor: UIColor = UIColor.orangeColor()

enum GameState {
    case GameIsReady
    case GameIsPlaying
    case GameIsPaused
}

class RootViewController: UIViewController, GameBoardDelegate, GameControlViewDelegate, GKGameCenterControllerDelegate
  {
    var highestScore: Int64 = 0
    var totalScore: Int64 = 0
    var leftGameBoard: GameBoard?
    var rightGameBoard: GameBoard?
    var gameCenterController: GKGameCenterViewController?
    var gameControlView: GameControlView?
    var settingNavigationController: UINavigationController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameControlView = NSBundle.mainBundle().loadNibNamed("GameControlView", owner: nil, options: nil)[0] as? GameControlView
        gameControlView?.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        edgesForExtendedLayout = UIRectEdge.None
        title = NSLocalizedString("Easy Snake Game", comment: "")
        configureNavigationItem()
        
        if NSUserDefaults.standardUserDefaults().valueForKey("HighestScore") != nil {
            highestScore = Int64(NSUserDefaults.standardUserDefaults().integerForKey("HighestScore"))
        }
    }
    
    func drawGameBoards() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        
        let width: CGFloat = UIScreen.mainScreen().bounds.width
        // 竖屏:44+20
        // 横屏:32+20
        let extraHeight: CGFloat = 0 // 32 + 20
        let height: CGFloat = UIScreen.mainScreen().bounds.height - extraHeight
        
        leftGameBoard = GameBoard(frame: CGRectMake(0, 0, width/2, height))
        leftGameBoard?.backgroundColor = UIColor.whiteColor()
        leftGameBoard?.SnakeColor = SnakeColor
        leftGameBoard?.initGameBord()
        leftGameBoard?.delegate = self
        view.addSubview(self.leftGameBoard!);
        
        rightGameBoard = GameBoard(frame: CGRectMake(width/2, 0, width/2, height))
        rightGameBoard?.backgroundColor = UIColor.whiteColor()
        rightGameBoard?.SnakeColor = SnakeColor
        rightGameBoard?.initGameBord()
        rightGameBoard?.delegate = self
        view.addSubview(self.rightGameBoard!);
        
        self.view.bringSubviewToFront(gameControlView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        print("width=\(self.view.frame.size.width)")
        print("height=\(self.view.frame.size.height)")
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        drawGameBoards();
        
        self.view.addSubview(gameControlView!)
        gameControlView?.setHighestScore(highestScore)
        gameControlView?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    // MARK: - Private
    func configureNavigationItem()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "得分：0", style: UIBarButtonItemStyle.Plain, target: self, action: "onRankButtonClicked:")
        
        let startButton = UIBarButtonItem(title: "开始", style: UIBarButtonItemStyle.Plain, target: self, action: "onStartGameButtonClicked:")
        let settingButton = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: "onSettingButtonClicked:")
        navigationItem.rightBarButtonItems = [settingButton, startButton]
    }
    
    func share() {
        UMSocialSnsService.presentSnsIconSheetView(self, appKey:"56f2ad62e0f55a0548002657", shareText:"我在测试", shareImage:nil, shareToSnsNames:[UMShareToSina, UMShareToRenren, UMShareToDouban, UMShareToWechatTimeline, UMShareToWechatSession, UMShareToQzone], delegate:nil)
    }
    
    func resetGame() {
        let startButton = self.navigationItem.rightBarButtonItems![1]
        startButton.title = "开始"
        navigationItem.leftBarButtonItem?.title = "得分：0"
        totalScore = 0
        
        leftGameBoard?.resetGame()
        rightGameBoard?.resetGame()
    }
    
    // MARK: - Button actions
    func onStartGameButtonClicked(sender: UIButton)
    {
        let startButton = self.navigationItem.rightBarButtonItems![1]
        let title = startButton.title
        if title == "开始" {
            startButton.title = "暂停"
            leftGameBoard?.startGame()
            rightGameBoard?.startGame()
        } else { // 暂停游戏
            startButton.title = "开始"
            leftGameBoard?.pauseGame()
            rightGameBoard?.pauseGame()
        }
    }
    
    func onSettingButtonClicked(sender:UIButton) {
        let controller = SettingViewController(nibName:"SettingViewController", bundle:nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - GameControlViewDelegate
    func gameControlViewDidClickedStartGameButton() {
        self.leftGameBoard?.startGame()
        self.rightGameBoard?.startGame()
    }
    
    func gameControlViewDidClickedLeaderBoardButton() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if  localPlayer.authenticated {
            showLeaderBoard()
        } else {
            authenticateLocalUserWithSucess({ () -> Void? in
                self.showLeaderBoard()
            })
        }
    }
    
    func gameControlViewDidClickedSettingButton() {
        let settingViewController = SettingViewController(nibName:"SettingViewController", bundle:nil)
        settingNavigationController = UINavigationController(rootViewController: settingViewController)
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        closeButton.setTitle(NSLocalizedString("Close", comment: ""), forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "OnCloseButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        settingViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        self.presentViewController(settingNavigationController!, animated: true, completion: nil)
    }
    
    func OnCloseButtonClicked() {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - GameBoardDelegate
    func gameScoreChanged(score: Int) {
        totalScore += score;
        print("totalScore = \(totalScore)")
        navigationItem.leftBarButtonItem?.title = "得分：\(totalScore)"
    }
    
    func gameOver() {
        leftGameBoard?.stopTimer()
        rightGameBoard?.stopTimer()
        // 提交游戏得分
        authenticateLocalUserWithSucess { () -> Void? in
            self.reportScore()
        }
        
        if  totalScore > highestScore {
            highestScore = totalScore
            NSUserDefaults.standardUserDefaults().setInteger(Int(highestScore), forKey: "HighestScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        print("totalScore\(totalScore)")
        gameControlView?.setHighestScore(highestScore)
        gameControlView?.setCurrentScore(totalScore)
        gameControlView?.show()
        
        resetGame()
    }
    
    // MARK: - LeaderBoard
    func authenticateLocalUserWithSucess(success:()->Void?) {
        let localPlayer = GKLocalPlayer.localPlayer()
        if  localPlayer.authenticated {
            success()
            return
        }
        
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: NSError?) -> Void in
            if  viewController == nil {
                if localPlayer.authenticated {
                    print("授权成功")
                    success()
                } else {
                    print("授权失败\(error)");
                }
            } else {
                self.presentViewController(viewController!, animated: true
                    , completion: nil)
            }
        }
    }
    
    func showLeaderBoard() {
        let gameCenterController = GKGameCenterViewController()
        gameCenterController.gameCenterDelegate = self
        gameCenterController.viewState = GKGameCenterViewControllerState.Default
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScope.Today
        gameCenterController.leaderboardIdentifier = LeaderBoardID
        self.presentViewController(gameCenterController, animated: true, completion: nil)
    }
    
    func authenticateLocalUser() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if  localPlayer.authenticated {
            showLeaderBoard()
        }
        
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: NSError?) -> Void in
            if  viewController == nil {
                if localPlayer.authenticated {
                    print("授权成功")
                } else {
                    print("授权失败\(error)");
                }
            } else {
                self.presentViewController(viewController!, animated: true
                    , completion: nil)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        print("点击完成了")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 提交得分
    func reportScore() {
        if totalScore < highestScore {
            return
        }
        
        let score: GKScore = GKScore(leaderboardIdentifier: LeaderBoardID)
        score.value = totalScore
        GKScore.reportScores([score]) { (error: NSError?) -> Void in
            if  error == nil {
                print("提交成功")
            } else {
                print("提交失败")
            }
        }
    }
}
