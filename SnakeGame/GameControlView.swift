//
//  GameControlView.swift
//  SnakeGame
//
//  Created by lichunwang on 16/3/30.
//  Copyright © 2016年 thunder. All rights reserved.
//

import UIKit

protocol GameControlViewDelegate {
    func gameControlViewDidClickedStartGameButton()
    func gameControlViewDidClickedLeaderBoardButton()
    func gameControlViewDidClickedShareButton()
    func gameControlViewDidClickedSettingButton()
}

class GameControlView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var leaderBoardButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var highestScoreTipsLabel: UILabel!
    @IBOutlet weak var currentScoreTipsLabel: UILabel!
    
    var delegate: GameControlViewDelegate?
    
    override func awakeFromNib() {
        // 设置阴影效果
        self.layer.shadowColor = UIColor.blackColor().CGColor // 阴影颜色
        self.layer.shadowOffset = CGSizeMake(0, 0); //阴影偏移
        self.layer.shadowRadius = 8.0 // 阴影半径，默认为为3
        self.layer.shadowOpacity = 1 // 阴影透明度，默认为0
        
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor(red: 0, green: 174/255, blue: 187/255, alpha: 1)
        startGameButton.layer.cornerRadius = 5
        leaderBoardButton.layer.cornerRadius = 5
        shareButton.layer.cornerRadius = 5
        settingButton.layer.cornerRadius = 5
        
        startGameButton.setTitle(NSLocalizedString("Play", comment:""), forState: UIControlState.Normal)
        leaderBoardButton.setTitle(NSLocalizedString("Leader Board", comment:""), forState: UIControlState.Normal)
        shareButton.setTitle(NSLocalizedString("Share", comment:""), forState: UIControlState.Normal)
        settingButton.setTitle(NSLocalizedString("Settings", comment:""), forState: UIControlState.Normal)
        
        currentScoreTipsLabel.text = NSLocalizedString("Your Score", comment:"")
        highestScoreTipsLabel.text = NSLocalizedString("Highest Score", comment:"")
        
        startGameButton.backgroundColor = GameBoardColor
        leaderBoardButton.backgroundColor = GameBoardColor
        shareButton.backgroundColor = GameBoardColor
        settingButton.backgroundColor = GameBoardColor
        
        startGameButton.setTitleColor(GameControllerTextColor, forState: UIControlState.Normal)
        leaderBoardButton.setTitleColor(GameControllerTextColor, forState: UIControlState.Normal)
        shareButton.setTitleColor(GameControllerTextColor, forState: UIControlState.Normal)
        settingButton.setTitleColor(GameControllerTextColor, forState: UIControlState.Normal)
        
        currentScoreLabel.textColor = GameControllerTextColor
        highestScoreLabel.textColor = GameControllerTextColor
        currentScoreTipsLabel.textColor = GameControllerTextColor
        highestScoreTipsLabel.textColor = GameControllerTextColor
    }

    func dismissWithBlock(block:() -> Void) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0
            }) { (Bool) -> Void in
                block()
        }
    }
    
    func setCurrentScore(currentScore: Int64) {
        currentScoreLabel.text = String(currentScore)
    }
    
    func setHighestScore(highestScore: Int64) {
        highestScoreLabel.text = String(highestScore)
    }

    func show() {
        self.hidden = false
        self.alpha = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.alpha = 1
        }
    }
    
    @IBAction func onStartGameButtonClicked(sender: AnyObject) {
        dismissWithBlock { () -> Void in
            self.delegate?.gameControlViewDidClickedStartGameButton()
        }
    }

    @IBAction func onLeaderBoardButtonClicked(sender: AnyObject) {
        self.delegate?.gameControlViewDidClickedLeaderBoardButton()
    }
    
    @IBAction func onShareButtonClicked(sender: AnyObject) {
        self.delegate?.gameControlViewDidClickedShareButton()
    }
    
    @IBAction func onSettingButtonClicked(sender: AnyObject) {
        self.delegate?.gameControlViewDidClickedSettingButton()
    }
}
