//
//  SettingViewController.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/23.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit
import GameKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: - Property
//    let gameDifficulty = NSLocalizedString("Game Difficulty", comment:"")
    let feedback = NSLocalizedString("Feedback", comment:"")
    let about = NSLocalizedString("About", comment:"")
    var tableViewDatasources: [String]?
    
    let lowDiff = NSLocalizedString("Low Difficulty", comment:"")
    let midDiff = NSLocalizedString("Middle Difficulty", comment:"")
    let highDiff = NSLocalizedString("High Difficulty", comment:"")
    var pickerViewDatasources: [String]?

    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDatasources = [feedback, about]
        pickerViewDatasources = [lowDiff, midDiff, highDiff]
        
        self.title = NSLocalizedString("Settings", comment:"")
        finishButton.setTitle(NSLocalizedString("Done", comment:""), forState: UIControlState.Normal)
        
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
    
    func showScoreHistoryViewController() {
        let historyViewController = ScoreHistoryViewController()
        self.navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    //MARK: - IBAction
    @IBAction func onFinishButtonClicked(sender: AnyObject) {
        hidePickerView()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableViewDatasources?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = tableViewDatasources?[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        hidePickerView()
        switch indexPath.row {
//        case 0:
//            showPickerView()
//            print("0")
            
        case 0:
            print("1")
            showFeedbackViewController()
        
        case 1:
            print("2")
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
        return (pickerViewDatasources?.count)!
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewDatasources?[row]
    }
}
