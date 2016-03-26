

import UIKit

class ColumnIndicator: UIView {
    var space = CGFloat(0)
    var labels = [UILabel]()
    var ColumnCount = 0
    var ColumnNumber: Int!
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
    
    
    func frameWithColumnNumber(Column: Int) -> CGRect{
        var frame = CGRect()
        frame.size.width = self.bounds.width
        frame.size.height = self.numberHeight
        return frame
    }
    
    func changeCenterWithColumnNumber(Column: Int, label: UILabel){
        label.center.x = self.topSpace + 0.5*self.numberHeight + CGFloat(Column-1)*self.space
        
    }
    
    
    func initializeIndicator(height: CGFloat, numberHeight: CGFloat = 15, ColumnNumber: Int, exclude: [Int]){
        self.frame.size.height = height
        self.ColumnNumber = ColumnNumber
        self.numberHeight = CGFloat(numberHeight)
        
        for _ in 0..<ColumnNumber{
            self.ColumnCount += 1
            let label = UILabel(frame: self.frameWithColumnNumber(ColumnCount))
            defer { self.addSubview(label); self.labels.append(label) }
            if exclude.contains(self.ColumnCount){
                continue
            }
            label.text = "\(ColumnCount)"
            label.textAlignment = .Center
            label.textColor = UIColor.whiteColor()
        }
        self.frame.size.width = self.topSpace + self.numberHeight + CGFloat(ColumnNumber-1)*self.space
    }
    
    func updateUI(x: CGFloat, space: CGFloat! = nil){
        if space == nil{
            self.center.x = x
            return
        }
        self.space = space
        self.frame.size.height = self.topSpace + self.numberHeight + CGFloat(ColumnNumber-1)*self.space
        self.center.x = x
        for i in 0..<self.labels.count{
            let label = self.labels[i]
            changeCenterWithColumnNumber(i+1, label: label)
        }
        
    }
    
    func flip(){
        for label in self.labels{
            label.text = "\(self.ColumnNumber - Int(label.text!)! + 1)"
        }
    }
    
    
}
