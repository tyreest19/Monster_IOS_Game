//
//  dragImage.swift
//  mymonster
//
//  Created by Tyree Stevenson on 1/31/16.
//  Copyright © 2016 Tyree Stevenson. All rights reserved.
//

import Foundation
import UIKit

class Drag: UIImageView {
    
    var orginalPosition: CGPoint!
    var dropTarget: UIView?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        orginalPosition = self.center
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x, position.y)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
       self.center = orginalPosition
        
        if let touch = touches.first, let target = dropTarget {
            let position = touch.locationInView(self.superview)
            if CGRectContainsPoint(target.frame, position) {
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil)) 
            }
        }
        
        
    }
   
    
    
    
    
}
