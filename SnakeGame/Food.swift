//
//  Food.swift
//  SnakeGame
//
//  Created by wanglichun on 15/10/22.
//  Copyright © 2015年 thunder. All rights reserved.
//

import UIKit

class Food: UIView {
    
    init(parentView:UIView, position: CGPoint)
    {
        let frame: CGRect = CGRectMake(position.x, position.y, SnakeBlobSize, SnakeBlobSize)
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        parentView.addSubview(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}