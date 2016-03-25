//
//  SeatView.swift
//  SeatsScrollView
//
//  Created by Harold on 15/8/19.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
protocol SeatViewDelegate {
    func didSelectSeatAtIndexPath(indexPath: NSIndexPath, seatButton: SeatButton)
}
protocol SeatViewDataSource {
    func numberOfRows() -> Int
    func numberOfColumns() -> Int
    func seatStatusAtIndexPath(indexPath:NSIndexPath) -> SeatStatus
}

class SeatView: UIView, UIScrollViewDelegate,UITableViewDelegate{
    
    
    var scrollView = UIScrollView()
    let rowSpace = CGFloat(10) // height of the spaces between rows
    let columnSpace = CGFloat(5)// width of the spaces between columns
    var rows:Int!// number of rows
    var columns:Int!// number of columns
    let seatSideLength = CGFloat(30)
    var seatsTotalWidth:CGFloat! // width of all seats excluding the platform
    var seatsTotalHeight:CGFloat! // height of all seats excluding the platform
    var maxBoundsSize:CGSize!
    var seatMapSize:CGSize!
    let margin = CGFloat(15)
    let platformWidth = CGFloat(100)
    let platformHeight = CGFloat(60)
    let platformSpace = CGFloat(50)
    var seatView = UIView() // super view of all seat buttons
    var miniMap:UIView! // root view of the mini seat map
    var miniSeatView = UIView() // super view of all mini seat
    var miniSeatIndicator:UIView! // the rectangle in the mini map indicating where you are
    let viewRatio = CGFloat(5) // mini map ratio
    var delegate:SeatViewDelegate!
    var dataSource:SeatViewDataSource!
    var seatButtonArray: [[SeatButton]]! // stores all seat buttons in accordance with their actual row and column info
    var seatButtonForRotation = [[SeatButton]]() // stores all seat buttons (subscripts give you the seat button on the screen at the given row and column, not the actual seat as the seats can be rotated 180 degrees)
    var platformLabel = UILabel() // a label representing the platform
    var up = true // indicating the direction of the seat map (the platform at the top or bottom of the map)
    var rowIndicator: RowIndicator!
    var basePoint: CGPoint!
    var baseContentOffset: CGPoint!
    var fisrtSeatCenter: CGPoint!
    var firstSeat: SeatButton!
    var lastSeat: SeatButton!
    var baseRowSpace = CGFloat(0)
    var blankBackground = UIView()
    var contentSize: CGSize!
    override var frame: CGRect {
        didSet {
           
            
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        self.scrollView.delegate = self
        rows = self.dataSource.numberOfRows()
        columns = self.dataSource.numberOfColumns()
        
        self.seatsTotalHeight = CGFloat(rows) * self.seatSideLength + self.rowSpace * CGFloat(self.rows - 1)
        self.seatsTotalWidth = CGFloat(columns) * self.seatSideLength + self.columnSpace * CGFloat(self.columns - 1)
        
        
        self.seatButtonArray = [[SeatButton]]()
        self.seatButtonForRotation = [[SeatButton]]()
        self.initScrollView()
        self.initMiniMap()
        
        self.rowIndicator = RowIndicator(frame: CGRect(x: self.bounds.origin.x, y: 1, width: 1, height: 1))
        self.rowIndicator.initializeIndicator(0.05*self.bounds.width, numberHeight: firstSeat.frame.height, rowNumber: self.seatButtonArray.count, exclude: [])
        self.baseRowSpace = (self.seatSideLength+self.rowSpace)*self.scrollView.zoomScale
        self.rowIndicator.updateUI(self.getMapCenterY(), space: self.baseRowSpace)
        self.addSubview(self.rowIndicator)
        
        self.scrollView.contentSize = CGSizeMake(max(self.seatMapSize.width, self.scrollView.frame.width), max(self.seatMapSize.height, self.scrollView.frame.height))
        
        self.blankBackground.backgroundColor = self.seatView.backgroundColor
        
    }
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.scrollView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollView.delegate = self
    }
    
    
    func getMapCenterY() -> CGFloat{
        let mapCenter = CGPoint(x: 0, y: 0.5*(self.lastSeat.center.y+self.firstSeat.center.y))
        let newCenter = self.seatView.convertPoint(mapCenter, toView: self)
        return newCenter.y

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
        // flip the platform
        if self.up{
            self.platformLabel.center.y = self.platformLabel.center.y + (self.seatsTotalHeight + 2 * self.platformSpace + self.platformHeight)
        }
        else{
            self.platformLabel.center.y = self.platformLabel.center.y - (self.seatsTotalHeight + 2 * self.platformSpace + self.platformHeight)
        }
        self.up = !self.up
    }
    func initMiniMap(){
        
        self.miniMap = UIView(frame: CGRectMake(10, 10, self.contentSize.width/self.viewRatio, self.contentSize.height/self.viewRatio))
        self.miniMap.clipsToBounds = true;
        
        self.miniSeatView.backgroundColor = UIColor.blackColor()
        self.miniMap.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        self.addSubview(self.miniMap)
        self.miniSeatIndicator = UIView(frame: CGRectMake(self.scrollView.contentOffset.x/self.viewRatio/self.scrollView.zoomScale, self.scrollView.contentOffset.y/self.viewRatio/self.scrollView.zoomScale, seatMapSize.width/self.viewRatio/self.scrollView.zoomScale,
            self.seatMapSize.height/self.viewRatio/self.scrollView.zoomScale))
        self.miniSeatIndicator.layer.borderWidth = 1
        self.miniSeatIndicator.layer.borderColor = UIColor.redColor().CGColor
        self.miniSeatIndicator.backgroundColor = UIColor.clearColor()
        
        var transform = self.miniSeatView.transform
        transform = CGAffineTransformScale(transform, 1/self.viewRatio/self.scrollView.zoomScale,1/self.viewRatio/self.scrollView.zoomScale)
        
        self.miniSeatView.transform = transform
  
        self.miniSeatView.center = CGPointMake(self.miniMap.bounds.width/2, self.miniMap.bounds.height/2)
        self.miniSeatView.backgroundColor = UIColor.clearColor()
        
        self.miniMap.addSubview(self.miniSeatView)
        self.miniMap.addSubview(self.miniSeatIndicator)
        self.hideMiniMap()
        
    }
    
    
    
    
    func initScrollView(){
        self.scrollView.frame = self.bounds
        self.blankBackground.frame = self.bounds
        self.scrollView.addSubview(self.blankBackground)//self.blankBackground)
        self.blankBackground.backgroundColor = UIColor.blueColor()
        self.addSubview(self.scrollView)
        
       

        
        
        for row in 0..<self.rows{
            var temp = [SeatButton]()
            for column in 0..<self.columns{
                let seat = SeatButton()
                seat.exclusiveTouch = true
                let seatStatus = self.dataSource.seatStatusAtIndexPath(NSIndexPath(forRow: row, inSection: column))
                seat.row = row
                seat.column = column
                seat.status = seatStatus
                temp.append(seat)
                let miniSeat = seat.miniSeat
                let y = CGFloat(row) * (self.seatSideLength + self.rowSpace) + self.margin + self.platformHeight + self.platformSpace
                let x : CGFloat = CGFloat(column) * (self.seatSideLength + self.columnSpace) + self.margin
                seat.frame = CGRectMake(x, y, self.seatSideLength, self.seatSideLength)
                miniSeat.frame = seat.frame
                seat.addTarget(self, action: #selector(SeatView.seatClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.seatView.addSubview(seat)
                self.miniSeatView.addSubview(miniSeat)
                
            }
            self.seatButtonArray.append(temp)
            self.seatButtonForRotation.append(temp)
            
        }
        
        self.seatMapSize = CGSizeMake(self.seatsTotalWidth + 2*self.margin, self.seatsTotalHeight+2*self.margin+self.platformSpace+self.platformHeight)
        self.firstSeat = self.seatButtonArray[0][0]
        self.fisrtSeatCenter = self.seatView.convertPoint(self.firstSeat.center, fromCoordinateSpace: self)
        self.lastSeat = self.seatButtonArray.last?.last
        
        
        
        self.platformLabel.frame.size = CGSizeMake(self.platformWidth, self.platformHeight)
        self.platformLabel.center.x = self.firstSeat.frame.origin.x + (self.seatsTotalWidth) / 2
        self.platformLabel.center.y = self.firstSeat.frame.origin.y - self.platformSpace - platformLabel.frame.height / 2
        self.platformLabel.text = "讲台"
        self.platformLabel.layer.cornerRadius = 5.0
        self.platformLabel.textAlignment = .Center
        self.platformLabel.backgroundColor = UIColor.whiteColor()
        self.seatView.addSubview(platformLabel)
    
        
        
        
        
        
        
        self.calculate()
        self.seatView.frame.size = self.seatMapSize
        self.blankBackground.addSubview(self.seatView)
        self.seatView.center = self.blankBackground.center
        
       //self.scrollView.frame.origin.y += 20
        self.scrollView.bounces = true
        self.scrollView.maximumZoomScale = 5
        self.scrollView.minimumZoomScale = 1
        
        //self.seatView.frame.origin = self.scrollView.bounces.origin
        self.seatView.backgroundColor = UIColor(white: CGFloat(0.9), alpha: 1)
        
    
        self.scrollView.backgroundColor = self.seatView.backgroundColor
        
        
        self.miniSeatView.backgroundColor = UIColor.clearColor()
        self.miniSeatView.frame.size = self.seatView.frame.size
        
        
        
        
        
        
       
        
        
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
        self.rowIndicator.updateUI(self.getMapCenterY(), space: self.baseRowSpace*self.scrollView.zoomScale)
        self.miniSeatIndicator.frame = CGRectMake(self.miniSeatIndicator.frame.origin.x
            , self.miniSeatIndicator.frame.origin.y,
            self.frame.width/self.viewRatio/self.scrollView.zoomScale,
            self.frame.height/self.viewRatio/self.scrollView.zoomScale)
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !self.scrollView.zooming{
            self.rowIndicator.updateUI(self.getMapCenterY())
        }
        
        
        if self.miniSeatIndicator == nil{
            return
        }
        
        self.miniMap.hidden = false
        self.miniSeatIndicator.frame = CGRectMake(self.scrollView.contentOffset.x/viewRatio/self.scrollView.zoomScale, self.scrollView.contentOffset.y/viewRatio/self.scrollView.zoomScale, miniSeatIndicator.frame.size.width,
            miniSeatIndicator.frame.size.height)
    }
    
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.blankBackground
    }
    
    func centerView(){
        let offsetX = -(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5
        let offsetY = -(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5
        scrollView.contentOffset = CGPointMake(offsetX, offsetY)
        
    }
    
    func calculate(){
        self.maxBoundsSize = self.scrollView.bounds.size
        self.contentSize = CGSizeMake(max(2*self.margin + self.seatsTotalWidth, self.maxBoundsSize.width), max(2*self.margin + self.seatsTotalHeight + self.platformHeight, self.maxBoundsSize.height))
       
        
        
    }
    
    func seatClicked(seat:SeatButton){
        self.delegate.didSelectSeatAtIndexPath(NSIndexPath(forRow: seat.row, inSection: seat.column), seatButton: seat)
    }
    
    func changeSeatStatusAtIndexPath(indexPath: NSIndexPath, seatStatus: SeatStatus){
        let seat = self.seatButtonArray[indexPath.row][indexPath.section]
        seat.status = seatStatus
    }
    
}
