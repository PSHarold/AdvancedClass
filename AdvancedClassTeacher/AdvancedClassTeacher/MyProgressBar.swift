//
//  MyProgressBar.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit
class MyProgressBar: UIView {
    
    private let π = CGFloat(M_PI)
    private let botCircle = CAShapeLayer()
    private let progressCircle = CAShapeLayer()
    private var circlePath = UIBezierPath()
    private var textLabel = UILabel()
    
     var botCircleColor: UIColor = UIColor.grayColor()
     var progressCircleColor: UIColor = UIColor.greenColor()
     var lineWidth: Float = 10
     var totalNumber: Int = 100
     var valueFontSize: Int = 40
     var _currentNum: Int = 0
     var currentNumber: Int{
        get{
            return self._currentNum
        }
        set{
            if newValue < 0{
                self._currentNum = 0
            }
            else if newValue > self.totalNumber{
                self._currentNum = self.totalNumber
            }
            else{
                self._currentNum = newValue
            }
            setNeedsDisplay()
        }
    }
    var percentage: CGFloat{
        get{
            if self.totalNumber == 0{
                return 0.0
            }
            return CGFloat(self.currentNumber)/CGFloat(self.totalNumber)
        }
    }
    private func calcArc(arc: CGFloat) -> CGFloat {
        return π * arc / 180
    }
    
    private func formatPercent() -> NSMutableAttributedString {
        
        let string = String("\(self.currentNumber)/\(self.totalNumber)") as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        
        let numColor = UIColor.blackColor()
        let firstAttributes = [NSForegroundColorAttributeName: numColor,
            NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(valueFontSize))]
    
        
        attributedString.addAttributes(firstAttributes, range: string.rangeOfString(String(string)))
        
        return attributedString
    }
    
    override func drawRect(rect: CGRect) {
        
        // define the path
        let centerPointCircle = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = bounds.width / 2 * 0.8
        circlePath = UIBezierPath(arcCenter: centerPointCircle, radius: radius, startAngle: calcArc(-90), endAngle: calcArc(270), clockwise: true)
        
        // define background circle
        botCircle.path = circlePath.CGPath
        botCircle.strokeColor = botCircleColor.CGColor
        botCircle.fillColor = UIColor.clearColor().CGColor
        botCircle.lineWidth = CGFloat(lineWidth)
        botCircle.strokeStart = 0
        botCircle.strokeEnd = 1
        
        // define progress circle
        progressCircle.path = circlePath.CGPath
        progressCircle.strokeColor = progressCircleColor.CGColor
        progressCircle.fillColor = UIColor.clearColor().CGColor
        progressCircle.lineWidth = CGFloat(lineWidth)
        progressCircle.strokeStart = 0
        progressCircle.strokeEnd = CGFloat(percentage)
        
        // define UIlabel
        textLabel.frame = CGRect(origin: CGPoint(x: circlePath.bounds.minX, y: circlePath.bounds.minY), size: circlePath.bounds.size)
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.numberOfLines = 0
        textLabel.layer.cornerRadius = radius
        textLabel.layer.masksToBounds = true
        textLabel.attributedText = formatPercent()
        
        addSubview(textLabel)
        
        layer.addSublayer(botCircle)
        layer.addSublayer(progressCircle)
    }
}