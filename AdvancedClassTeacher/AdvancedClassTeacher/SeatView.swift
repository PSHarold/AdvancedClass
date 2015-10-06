//
//  SeatView.swift
//  SeatsScrollView
//
//  Created by Harold on 15/8/19.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
protocol SeatViewDelegate {
    func didSelectSeatAtIndexPath(indexPath: NSIndexPath)
}
protocol SeatViewDataSource {
    func numberOfRows() -> Int
    func numberOfColumns() -> Int
    func seatAtIndexPath(indexPath:NSIndexPath) -> SeatButton
}

class SeatView: UIView, UIScrollViewDelegate,UITableViewDelegate{

    
    var scrollView = UIScrollView()
    let rowSpace = CGFloat(10) // height of the spaces between rows
    let columnSpace = CGFloat(5)// width of the spaces between columns
    var rows:Int!// number of rows
    var columns:Int!// number of columns
    let seatSideLength = CGFloat(30)
    var totalWidth:CGFloat! // width of all seats excluding the platform
    var totalHeight:CGFloat! // height of all seats excluding the platform
    var maxBoundsSize:CGSize!
    var contentSize:CGSize!
    let margin = CGFloat(15)
    let platformWidth = CGFloat(200)
    let platformHeight = CGFloat(60)
    let platformSpace = CGFloat(50)
    var seatView = UIView() // super view of all seat buttons
    var miniMap:UIView! // root view of the mini seat map
    var miniSeatView = UIView() // super view of all mini seat
    var miniSeatIndicator:UIView! // the rectangle in the mini map indicating where you are
    let viewRatio = CGFloat(5) // mini map ratio
    var delegate:SeatViewDelegate!
    var dataSource:SeatViewDataSource!
    var seatButtonArray = [[SeatButton]]() // stores all seat buttons in accordance with their actual row and column info
    var seatButtonForRotation = [[SeatButton]]() // stores all seat buttons (subscripts give you the seat button on the screen at the given row and column, not the actual seat as the seats can be rotated 180 degrees)
    var platformLabel = UILabel() // a label representing the platform
    var up = true // indicating the direction of the seat map (the platform at the top or bottom of the map)
    
    override func drawRect(rect: CGRect) {
       // print("begin to draw rect")
        self.frame.size = rect.size
        rows = self.dataSource.numberOfRows()
        columns = self.dataSource.numberOfColumns()
        self.initScrollView()
        self.initMiniMap()
        
    }
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.scrollView.delegate = self
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollView.delegate = self
        
    }
    
    
    func flipSeats(){
        // flip vertically
        for j in 0..<self.columns{
            for i in 0..<self.rows/2{
                let seat = self.seatButtonForRotation[i][j]
                let oppositeSeat = self.seatButtonForRotation[self.rows - 1 - i][j]
                let tempFrame = seat.frame
                seat.frame = oppositeSeat.frame
                oppositeSeat.frame = tempFrame
                let tempMiniFrame = seat.miniSeat.frame
                seat.miniSeat.frame = oppositeSeat.miniSeat.frame
                oppositeSeat.miniSeat.frame = tempMiniFrame
                let tempSeat = seat
                self.seatButtonForRotation[i][j] = self.seatButtonForRotation[self.rows - 1 - i][j]
                self.seatButtonForRotation[self.rows - 1 - i][j] = tempSeat
            }
        }
        // then flip horizontally
        for i in 0..<self.rows{
            for j in 0..<self.columns/2{
                let seat = self.seatButtonForRotation[i][j]
                let oppositeSeat = self.seatButtonForRotation[i][self.columns - 1 - j]
                let tempFrame = seat.frame
                seat.frame = oppositeSeat.frame
                oppositeSeat.frame = tempFrame
                let tempMiniFrame = seat.miniSeat.frame
                seat.miniSeat.frame = oppositeSeat.miniSeat.frame
                oppositeSeat.miniSeat.frame = tempMiniFrame
                let tempSeat = seat
                self.seatButtonForRotation[i][j] = self.seatButtonForRotation[i][self.columns - 1 - j]
                self.seatButtonForRotation[i][self.columns - 1 - j] = tempSeat
            }
        }
        //flip the platform
        if self.up{
            self.platformLabel.center.y = self.platformLabel.center.y + (self.totalHeight + 2 * self.platformSpace + self.platformHeight)
        }
        else{
             self.platformLabel.center.y = self.platformLabel.center.y - (self.totalHeight + 2 * self.platformSpace + self.platformHeight)
        }
        self.up = !self.up
    }
    func initMiniMap(){
        self.miniMap = UIView(frame: CGRectMake(10, 10, self.seatView.frame.size.width/self.viewRatio, self.seatView.frame.size.height/self.viewRatio))
        self.miniMap.clipsToBounds = true;
       
        self.miniSeatView.backgroundColor = UIColor.blackColor()
        self.miniMap.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        self.addSubview(self.miniMap)
        self.miniSeatIndicator = UIView(frame: CGRectMake(self.scrollView.contentOffset.x/self.viewRatio/self.scrollView.zoomScale, self.scrollView.contentOffset.y/self.viewRatio/self.scrollView.zoomScale, self.frame.size.width/self.viewRatio/self.scrollView.zoomScale,
            self.frame.size.height/self.viewRatio/self.scrollView.zoomScale))
        self.miniSeatIndicator.layer.borderWidth = 1
        self.miniSeatIndicator.layer.borderColor = UIColor.redColor().CGColor
        self.miniSeatIndicator.backgroundColor = UIColor.clearColor()
        
        var transform = self.miniSeatView.transform
        transform = CGAffineTransformScale(transform, 1/self.viewRatio/self.scrollView.zoomScale,1/self.viewRatio/self.scrollView.zoomScale)
        
        self.miniSeatView.transform = transform
        self.miniSeatView.frame = self.miniMap.bounds
        self.miniSeatView.backgroundColor = UIColor.clearColor()
        
        self.miniMap.addSubview(self.miniSeatView)
        self.miniMap.addSubview(self.miniSeatIndicator)
        self.hideMiniMap()
        
    }
    
    
    
    
    func initScrollView(){
        self.calculate()
        self.scrollView.frame = self.bounds
        //print(self.scrollView.frame)
        self.scrollView.bounces = true
        self.scrollView.maximumZoomScale = 5
        self.scrollView.minimumZoomScale = 1
        self.seatView.frame.size = self.contentSize
        //self.seatView.frame.origin = self.scrollView.bounces.origin
        self.seatView.backgroundColor = UIColor(white: CGFloat(0.85), alpha: 1)
        self.scrollView.contentSize = self.contentSize
        self.scrollView.backgroundColor = self.seatView.backgroundColor
        for row in 0..<self.rows{
            var tempArray = [SeatButton]()
            var tempArrayForRotation = [SeatButton]()
            for column in 0..<self.columns{
                let seat = self.dataSource.seatAtIndexPath(NSIndexPath(forItem: column, inSection: row))
                seat.row = row
                seat.column = column
                let miniSeat = seat.miniSeat
                let y = CGFloat(row) * (self.seatSideLength + self.rowSpace) + (self.contentSize.height - self.totalHeight) / 2
                let x : CGFloat = CGFloat(column) * (self.seatSideLength + self.columnSpace) + (self.contentSize.width - self.totalWidth) / 2
                seat.frame = CGRectMake(x, y, self.seatSideLength, self.seatSideLength)
                miniSeat.frame = seat.frame
                seat.addTarget(self, action: "seatClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                self.seatView.addSubview(seat)
                self.miniSeatView.addSubview(miniSeat)
                tempArray.append(seat)
                tempArrayForRotation.append(seat)
            }
            self.seatButtonArray.append(tempArray)
            self.seatButtonForRotation.append(tempArrayForRotation)
        }
        
        self.platformLabel.frame.size = CGSizeMake(self.platformWidth, self.platformHeight)
        self.platformLabel.center.x = self.seatButtonArray[0][0].frame.origin.x + (self.totalWidth) / 2
        self.platformLabel.center.y = self.seatButtonArray[0][0].frame.origin.y - self.platformSpace - platformLabel.frame.height / 2
        self.platformLabel.text = "讲台"
        self.platformLabel.layer.cornerRadius = 5.0
        self.platformLabel.textAlignment = .Center
        self.platformLabel.backgroundColor = UIColor.whiteColor()
        self.miniSeatView.backgroundColor = UIColor.clearColor()
        self.scrollView.addSubview(self.seatView)
        self.seatView.addSubview(platformLabel)
        
        self.addSubview(self.scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            self.hideMiniMap()
        }
       
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        self.hideMiniMap()
    }
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.hideMiniMap()
    }
    
    func hideMiniMap(){
      //  UIView.transitionWithView(self.miniMap, duration: NSTimeInterval(0.2), options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {} , completion: ({completed in return}))
        self.miniMap.hidden = true
    }
    
    
    
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.miniSeatIndicator.frame = CGRectMake(self.miniSeatIndicator.frame.origin.x
            , self.miniSeatIndicator.frame.origin.y,
            self.frame.size.width/self.viewRatio/self.scrollView.zoomScale,
            self.frame.size.height/self.viewRatio/self.scrollView.zoomScale);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.miniSeatIndicator == nil{
            return
        }
        
        self.miniMap.hidden = false
        self.miniSeatIndicator.frame = CGRectMake(self.scrollView.contentOffset.x/viewRatio/self.scrollView.zoomScale, self.scrollView.contentOffset.y/viewRatio/self.scrollView.zoomScale, miniSeatIndicator.frame.size.width,
            miniSeatIndicator.frame.size.height)
    }
    
 
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.seatView
    }
    
    func centerView(){
        let offsetX = -(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5
        let offsetY = -(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5
        scrollView.contentOffset = CGPointMake(offsetX, offsetY)
        
    }
    
    func calculate(){
        self.maxBoundsSize = self.bounds.size
        self.totalHeight = CGFloat(rows) * self.seatSideLength + self.rowSpace * CGFloat(self.rows - 1)
        self.totalWidth = CGFloat(columns) * self.seatSideLength + self.columnSpace * CGFloat(self.columns - 1)
        self.contentSize = CGSizeMake(max(self.margin + self.totalWidth + self.platformWidth,self.maxBoundsSize.width), max(self.margin + self.totalHeight + self.platformHeight,self.maxBoundsSize.height))
        
        
    }
    
    func seatClicked(seat:SeatButton){
        self.delegate.didSelectSeatAtIndexPath(NSIndexPath(forItem: seat.column, inSection: seat.row))
    }
}
