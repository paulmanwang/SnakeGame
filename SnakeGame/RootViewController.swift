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
    var snake: Snake?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "贪吃蛇";
        self.view.backgroundColor = UIColor.yellowColor()
        
        self.snake = Snake(parentView: self.view, length: 10, direction: Direction.Right, originPoint: CGPoint(x: 0, y: 0))
        
        self.configureNavigationItem()
        
        self.addSwapGestures()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private
    func addSwapGestures()
    {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "handleSwapGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
    }
    
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
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timeout:", userInfo: nil, repeats: true)
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
        self.snake!.move()
    }
    
    // MARK - GestureRecognizer
    func handleSwapGesture(gestureRecongizer:UIGestureRecognizer)
    {
        if let swipeGesture = gestureRecongizer as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.Left:
                    print("向左")
                    self.snake?.changeDirection(Direction.Left)
                    
                case UISwipeGestureRecognizerDirection.Right:
                    print("向右")
                    self.snake?.changeDirection(Direction.Right)
                    
                case UISwipeGestureRecognizerDirection.Up:
                    print("向上")
                    self.snake?.changeDirection(Direction.Up)
                    
                case UISwipeGestureRecognizerDirection.Down:
                    print("向下")
                    self.snake?.changeDirection(Direction.Down)
                
                default:
                    break
            }
        }
    }
}
