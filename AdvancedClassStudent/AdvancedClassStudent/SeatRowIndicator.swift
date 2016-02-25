//
//  SeatRowIndicator.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/2/25.
//  Copyright © 2016年 Harold. All rights reserved.
//


import UIKit

class RowIndicator: UIView {
    var space = CGFloat(0)
    var labels = [UILabel]()
    var rowCount = 0
    var rowNumber: Int!
    var numberHeight: CGFloat = 15
    let topSpace = CGFloat(5)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        self.alpha = 0.8
        self.layer.cornerRadius = 10.0
    }
    
    
    func frameWithRowNumber(row: Int) -> CGRect{
        var frame = CGRect()
        frame.size.width = self.bounds.width
        frame.size.height = self.numberHeight
        //frame.origin.y = self.topSpace + CGFloat(row-1)*(self.numberHeight+self.space)
        return frame
    }
    
    func changeCenterWithRowNumber(row: Int, label: UILabel){
        label.center.y = self.topSpace + 0.5*self.numberHeight + CGFloat(row-1)*self.space
        
    }
    
    
    func initializeIndicator(width: CGFloat, numberHeight: CGFloat = 15, rowNumber: Int, exclude: [Int]){
        self.frame.size.width = width
        self.rowNumber = rowNumber
        self.numberHeight = CGFloat(numberHeight)
        
        for _ in 0..<rowNumber{
            ++self.rowCount
            let label = UILabel(frame: self.frameWithRowNumber(rowCount))
            defer { self.addSubview(label); self.labels.append(label) }
            if exclude.contains(self.rowCount){
                continue
            }
            label.text = "\(rowCount)"
            label.textAlignment = .Center
            label.textColor = UIColor.whiteColor()
        }
        self.frame.size.height = self.topSpace + self.numberHeight + CGFloat(rowNumber-1)*self.space
    }
    
    func updateUI(y: CGFloat, space: CGFloat! = nil){
        if space == nil{
            self.center.y = y
            return
        }
        self.space = space        
        self.frame.size.height = self.topSpace + self.numberHeight + CGFloat(rowNumber-1)*self.space
        self.center.y = y
        for i in 0..<self.labels.count{
            let label = self.labels[i]
            changeCenterWithRowNumber(i+1, label: label)
        }
        
        
    }
    
    
}
