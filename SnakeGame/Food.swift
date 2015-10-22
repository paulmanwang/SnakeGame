//
//  Food.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/22.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

enum FoodCategory
{
    case Humburg
    case Fruit
}

class Food: NSObject {
    
    var view: UIView?
    
    init(parentView:UIView, position: CGPoint)
    {
        let button: UIButton = UIButton(frame: CGRectMake(position.x, position.y, 20.0, 20.0))
        button.backgroundColor = UIColor.greenColor()
        self.view = button;
        parentView.addSubview(self.view!)
    }
}