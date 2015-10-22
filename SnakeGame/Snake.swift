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
    var direction: Direction?
    
    init(view: UIButton, currentDirection: Direction)
    {
        self.view = view
        self.direction = currentDirection
    }
}

class Snake: NSObject {
    var length: Int = 0
    var snakeBlobs: NSMutableArray
    var direction: Direction = Direction.Right
    let SnakeBlobWidth: CGFloat = 20.0
    
    // MARK: - Init
    init(parentView:UIView, length: Int, direction:Direction, originPoint:CGPoint)
    {
        self.snakeBlobs = NSMutableArray()
        self.length = length
        for var index = 0; index < length; ++index {
            let snakeButton = UIButton(frame: CGRectMake(SnakeBlobWidth * CGFloat(index), 0, SnakeBlobWidth, SnakeBlobWidth))
            snakeButton.backgroundColor = UIColor.redColor()
            snakeButton.layer.borderWidth = 1
            snakeButton.userInteractionEnabled = false
            let snakeBlob = SnakeBlob(view: snakeButton, currentDirection: Direction.Right)
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
    func move()
    {
        // 移动蛇身
        for var i = 0; i < self.snakeBlobs.count - 1; i++ {
            let snakeBlob = self.snakeBlobs[i] as? SnakeBlob
            let preSnakeBlob = self.snakeBlobs[i + 1] as? SnakeBlob
            
            let view1: UIButton = (snakeBlob?.view)!
            let view2: UIButton = (preSnakeBlob?.view)!
            
            view1.frame = view2.frame;
        }
        
        // 移动蛇头
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
    }
}
