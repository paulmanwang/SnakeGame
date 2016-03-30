//
//  SettingViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/23.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit
import GameKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GKGameCenterControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Property
    let tableViewDatasources = ["游戏难度", "意见反馈", "关于"]
    let pickerViewDatasources = ["低等难度", "中等难度", "高等难度"]

    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        tableView.tableFooterView = UIView()
        containerView.hidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Inner
    func showPickerView() {
        containerView.hidden = false
    }
    
    func hidePickerView() {
        containerView.hidden = true
    }
    
    func showAboutViewController() {
        let aboutViewController = UIViewController.init(nibName: "AboutViewController", bundle: nil)
        self.navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    func showFeedbackViewController() {
        let feedbackViewController = UMFeedback.feedbackModalViewController()
        self.navigationController?.pushViewController(feedbackViewController, animated: true)
    }
    
    //MARK: - IBAction
    @IBAction func onFinishButtonClicked(sender: AnyObject) {
        hidePickerView()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDatasources.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = tableViewDatasources[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        hidePickerView()
        switch indexPath.row {
        case 0:
            showPickerView()
            print("0")
            
        case 1:
            print("2")
            showFeedbackViewController()
        
        case 2:
            print("3")
            showAboutViewController()
            
        default:
            print("default")
        }
    }
    
    // MARK: - UIPickerDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewDatasources.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewDatasources[row]
    }
    
    // MARK: - LeaderBoard
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
                    self.showLeaderBoard()
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
}
