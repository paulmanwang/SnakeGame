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

let GameControllerTextColor = UIColor(red: 253/255, green: 208/255, blue: 0, alpha: 1)
let ScoreTextColor          = UIColor.redColor()
let GameBoardColor          = UIColor(red: 0, green: 174/255, blue: 187/255, alpha: 1)
let BorderColor             = UIColor.lightGrayColor()

let SnakeBodyImage          = UIImage(named: "snake_body")
let FoodImage               = UIImage(named: "food")

let SnakeHeadRightImage     = UIImage(named: "snake_head_right")
let SnakeHeadLeftImage      = UIImage(named: "snake_head_left")
let SnakeHeadDownImage      = UIImage(named: "snake_head_down")
let SnakeHeadUpImage        = UIImage(named: "snake_head_up")

let SnakeTailRightImage     = UIImage(named: "snake_tail_right")
let SnakeTailLeftImage      = UIImage(named: "snake_tail_left")
let SnakeTailDownImage      = UIImage(named: "snake_tail_down")
let SnakeTailUpImage        = UIImage(named: "snake_tail_up")

enum GameState {
    case GameIsReady
    case GameIsPlaying
    case GameIsPaused
}

class RootViewController: UIViewController, GameBoardDelegate, GameControlViewDelegate, GKGameCenterControllerDelegate, UMSocialUIDelegate
  {
    var highestScore: Int64 = 0
    var totalScore: Int64 = 0
    var leftGameBoard: GameBoard?
    var rightGameBoard: GameBoard?
    var gameCenterController: GKGameCenterViewController?
    var gameControlView: GameControlView?
    var settingNavigationController: UINavigationController?
    var scoreLabel: UILabel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GameBoardColor
        
        gameControlView = NSBundle.mainBundle().loadNibNamed("GameControlView", owner: nil, options: nil)[0] as? GameControlView
        gameControlView?.delegate = self
        
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
        
        // 计分板
        let labelWidth: CGFloat = 150
        let labelHeight: CGFloat = 80
        scoreLabel = UILabel(frame: CGRectMake(width - labelWidth - 20, 0, labelWidth, labelHeight))
        scoreLabel?.text = ""
        scoreLabel?.textColor = ScoreTextColor
        scoreLabel?.textAlignment = NSTextAlignment.Right
        scoreLabel?.font = UIFont.systemFontOfSize(60)
        scoreLabel?.backgroundColor = UIColor.clearColor()
        scoreLabel?.userInteractionEnabled = false
        view.addSubview(scoreLabel!)
        
        leftGameBoard = GameBoard(frame: CGRectMake(0, 0, width/2, height))
        leftGameBoard?.backgroundColor = UIColor.whiteColor()
        leftGameBoard?.initGameBord()
        leftGameBoard?.delegate = self
        view.addSubview(self.leftGameBoard!);
        
        rightGameBoard = GameBoard(frame: CGRectMake(width/2, 0, width/2, height))
        rightGameBoard?.backgroundColor = UIColor.whiteColor()
        rightGameBoard?.initGameBord()
        rightGameBoard?.delegate = self
        view.addSubview(self.rightGameBoard!)
        
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
    
    func resetGame() {
        let startButton = self.navigationItem.rightBarButtonItems![1]
        startButton.title = "开始"
        navigationItem.leftBarButtonItem?.title = "得分：0"
        
        leftGameBoard?.resetGame()
        rightGameBoard?.resetGame()
    }
    
    // MARK: - Button actions
    func onStartGameButtonClicked(sender: UIButton) {
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
        scoreLabel?.text = "0"
        totalScore = 0
        self.leftGameBoard?.startGame()
        self.rightGameBoard?.startGame()
    }
    
    func gameControlViewDidClickedLeaderBoardButton() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if  localPlayer.authenticated {
            // 提交游戏得分至得分榜
            if totalScore > highestScore {
                self.reportScoreWithSuccess({ () -> Void? in
                    self.showLeaderBoard()
                })
            } else {
                self.showLeaderBoard()
            }
        }
        else {
            let handler = {
                if (self.totalScore > self.highestScore) {
                    self.reportScoreWithSuccess({ () -> Void? in
                        self.showLeaderBoard()
                    })
                }
                else {
                   self.showLeaderBoard()
                }
            }
            self.authenticateLocalUserWithSucess(handler)
        }
    }
    
    func gameControlViewDidClickedSettingButton() {
        let settingViewController = SettingViewController(nibName:"SettingViewController", bundle:nil)
        settingNavigationController = UINavigationController(rootViewController: settingViewController)
        let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        closeButton.setTitle(NSLocalizedString("Close", comment: ""), forState: UIControlState.Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "OnCloseButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        settingViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        self.presentViewController(settingNavigationController!, animated: true, completion: nil)
    }
    
    func gameControlViewDidClickedShareButton() {
        self.share()
    }
    
    func OnCloseButtonClicked() {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - GameBoardDelegate
    func gameScoreChanged(score: Int) {
        print("score = \(score)")
        totalScore += score;
        if  totalScore < 10 {
            scoreLabel?.text = "0" + String(totalScore)
        } else {
            scoreLabel?.text = String(totalScore)
        }
        
        print("totalScore = \(totalScore)")
        navigationItem.leftBarButtonItem?.title = "得分：\(totalScore)"
    }
    
    func gameOver() {
        scoreLabel?.text = ""
        
        leftGameBoard?.stopTimer()
        rightGameBoard?.stopTimer()
        
//        // 利用coredata保存本次得分
//        ScoreManager.insertScore(totalScore)
        
        if  totalScore > highestScore {
            highestScore = totalScore
            NSUserDefaults.standardUserDefaults().setInteger(Int(highestScore), forKey: "HighestScore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
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
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        print("点击完成了")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 提交得分
    func reportScoreWithSuccess(success:()->Void?) {
        let score: GKScore = GKScore(leaderboardIdentifier: LeaderBoardID)
        score.value = totalScore
        GKScore.reportScores([score]) { (error: NSError?) -> Void in
            if  error == nil {
                print("提交成功")
                success()
            } else {
                print("提交失败")
                success()
            }
        }
    }
    
    // MARK: - Share
    
    func share() {
        // 设置分享图片
        let image = UIImage(named: "108x108")
        // 设置分享文字
        var content: String;
        if totalScore >= 10 {
        content = "我在双龙戏珠游戏中获取了\(totalScore)分，你敢来挑战吗?"
        } else {
            content = "我在双龙戏珠游戏中获取了\(totalScore)分，我就是一个傻瓜，快来拯救我吧"
        }
        
        // 设置分享标题
        UMSocialData.defaultData().extConfig.wechatSessionData.title = "本次战绩"
        // 设置分享类型，类型包括UMSocialWXMessageTypeImage、UMSocialWXMessageTypeText、UMSocialWXMessageTypeApp
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeApp;
        // 不设置type的时候才生效
        // UMSocialData.defaultData().extConfig.wechatSessionData.url = "http://baidu.com" // 不填写默认跳转到了UMeng首页
        
        UMSocialSnsService.presentSnsIconSheetView(self, appKey:"56f2ad62e0f55a0548002657", shareText:content, shareImage:image, shareToSnsNames:[UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline], delegate:self)
    }
    
    // 如果选择“留在微信”，不会有回调；如果选择“返回双龙戏珠”会有回调。
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if  response.responseCode == UMSResponseCodeSuccess {
            print("share to sns name is \(response.data)")
        }
    }
    
}
