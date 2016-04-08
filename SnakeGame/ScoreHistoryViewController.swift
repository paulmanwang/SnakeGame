//
//  ScoreHistoryViewController.swift
//  SnakeGame
//
//  Created by lichunwang on 16/4/8.
//  Copyright © 2016年 thunder. All rights reserved.
//

import UIKit

class ScoreHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var scoreList: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreList = ScoreManager.queryAllScores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (scoreList?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        let score: SGScore = scoreList![indexPath.row] as! SGScore
        cell.textLabel?.text = String(score.score) + "              " + String(score.addtime)
        return cell
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let score: SGScore = scoreList![indexPath.row] as! SGScore
        ScoreManager.deleteScoreWithScoreId(score.scoreid!)
        
        scoreList = ScoreManager.queryAllScores()
        tableView.reloadData()
    }
}
