//
//  Snake.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/20.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

enum Direction
{
    case Left
    case Right
    case Up
    case Down
}

class SnakeBlob {
    var view: UIButton?
    
    init(view: UIButton)
    {
        self.view = view
    }
}

class Snake: NSObject {
    var length: Int = 0
    var snakeBlobs: NSMutableArray
    var direction: Direction = Direction.Right
    let SnakeBlobWidth: CGFloat = 20.0
    var parentView: UIView?
    
    // MARK: - Init
    init(parentView:UIView, blobWidth: CGFloat, length: Int, defaultDirection:Direction, originPoint:CGPoint)
    {
        self.snakeBlobs = NSMutableArray()
        self.length = length
        self.parentView = parentView
        for var index = 0; index < length; ++index {
            let snakeButton = UIButton(frame: CGRectMake(SnakeBlobWidth * CGFloat(index), 0, SnakeBlobWidth, SnakeBlobWidth))
            snakeButton.backgroundColor = UIColor.redColor()
            snakeButton.layer.borderWidth = 1
            snakeButton.userInteractionEnabled = false
            let snakeBlob = SnakeBlob(view: snakeButton)
            parentView.addSubview(snakeBlob.view!)
            
            self.snakeBlobs.addObject(snakeBlob)
        }
    }
    
    // MARK: - Private APIs
    func isOppositeDirection(direction1:Direction, direction2:Direction) -> Bool {
        if (direction1 == Direction.Left && direction2 == Direction.Right)
            || (direction1 == Direction.Right && direction2 == Direction.Left)
            || (direction1 == Direction.Up && direction2 == Direction.Down)
            || (direction1 == Direction.Down && direction2 == Direction.Up)
        {
            return true
        }
        
        return false
    }
    
    // MARK: - Eat
    func eat()
    {
        self.length++;
    }
    
    // MARK: - Direction
    func changeDirection(newDirection: Direction)
    {
        if self.isOppositeDirection(self.direction, direction2: newDirection) { // 不能设置为相反方向
            return;
        }
        
        self.direction = newDirection
    }
    
    // MARK: - Move
    func moveWithFood(food:Food) -> Bool
    {
        var ret: Bool = false
        
        // 记录蛇尾的位置
        let tailSnakeBlob = self.snakeBlobs.firstObject as? SnakeBlob
        let tailRect: CGRect = (tailSnakeBlob?.view?.frame)!
        
        // 移动蛇身
        for var i = 0; i < self.snakeBlobs.count - 1; i++ {
            let snakeBlob = self.snakeBlobs[i] as? SnakeBlob
            let preSnakeBlob = self.snakeBlobs[i + 1] as? SnakeBlob
            
            let view1: UIButton = (snakeBlob?.view)!
            let view2: UIButton = (preSnakeBlob?.view)!
            
            view1.frame = view2.frame;
        }
        
        // 移动蛇头，可以穿墙
        let snakeBlob = self.snakeBlobs.lastObject as? SnakeBlob
        let view: UIButton = (snakeBlob?.view)!
        let originRect = view.frame
        switch self.direction {
            case .Left:
                view.frame = CGRectMake(originRect.origin.x - SnakeBlobWidth, originRect.origin.y, originRect.size.width, originRect.size.height)
            case .Right:
                view.frame = CGRectMake(originRect.origin.x + SnakeBlobWidth, originRect.origin.y, originRect.size.width, originRect.size.height)
            case .Up:
                view.frame = CGRectMake(originRect.origin.x, originRect.origin.y - SnakeBlobWidth, originRect.size.width, originRect.size.height)
            case .Down:
                view.frame = CGRectMake(originRect.origin.x , originRect.origin.y + SnakeBlobWidth, originRect.size.width, originRect.size.height)
        }
        
        // 蛇头位置与食物重合时，说明吃食成功。吃到食物时，蛇尾增加长度1
        if view.frame.origin == food.view?.frame.origin {
            ret = true
            food.view?.removeFromSuperview()
            
            let snakeButton = UIButton(frame: tailRect)
            snakeButton.backgroundColor = UIColor.redColor()
            snakeButton.layer.borderWidth = 1
            snakeButton.userInteractionEnabled = false
            let snakeBlob = SnakeBlob(view: snakeButton)
            self.parentView!.addSubview(snakeBlob.view!)
            
            self.snakeBlobs.insertObject(snakeBlob, atIndex: 0)
        }
        
        return ret
    }
    
}
