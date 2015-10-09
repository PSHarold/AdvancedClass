//
//  TeacherSeatViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/17.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherSeatViewController: UIViewController,SeatViewDataSource,SeatViewDelegate,TeacherSeatHelperDelegate,UITableViewDelegate,UITableViewDataSource{

    var seatHelper = TeacherSeatHelper.defaultHelper()
    var courseHelper = TeacherCourseHelper.defaultHelper()
    var timer:NSTimer!
    var seatButtonDict = Dictionary<String,SeatButton>()
    var seatButtonArray = [[SeatButton]]()
    var lastCheckedSeatButton:SeatButton?
    var lastCheckedSeat:Seat?
    var currentSeat:Seat?
    var studentHelper = TeacherStudentHelper.defaultHelper()
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var seatView:SeatView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seatHelper.delegate = self
        self.seatHelper.delegate = self
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.seatView.delegate = self
        self.seatView.dataSource = self
        self.infoTableView.separatorStyle = .None
        self.photo.layer.cornerRadius = 20.0
        self.photo.clipsToBounds = true
        self.photo.layer.masksToBounds = true
        for _ in 0..<self.seatHelper.rows{
            var temp = [SeatButton]()
            for _ in 0..<self.seatHelper.columns{
                temp.append(SeatButton())
            }
            self.seatButtonArray.append(temp)
        }
        
        for (id,seat) in self.seatHelper.seatDict{
            let tempSeat = self.seatButtonArray[seat.row - 1][seat.column - 1]
            self.seatButtonDict[id] = tempSeat
            tempSeat.checked = seat.checked
            tempSeat.taken = seat.taken
            
        }
        
        self.timer = NSTimer(timeInterval: 5.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    
    func didSelectSeatAtIndexPath(indexPath: NSIndexPath){
        let seat:Seat = self.seatHelper.seatArray[indexPath.section][indexPath.row]!
        let seatButton = self.seatAtIndexPath(indexPath)
        if !seat.taken{
            return
        }
        if seatButton.checked{
            seatButton.checked = false
            seatButton.taken = true
            self.currentSeat = nil
        }
        else if seatButton.taken{
            seatButton.taken = false
            seatButton.checked = true
            self.currentSeat = seat
        }
        if self.lastCheckedSeat !== seat{
            if self.lastCheckedSeat != nil{
                self.lastCheckedSeatButton?.checked = false
                self.lastCheckedSeatButton?.taken = true
            }
        }
        
        self.lastCheckedSeat = seat
        self.lastCheckedSeatButton = seatButton
        self.toggleStudentInfo()
    }
    
    
    func toggleStudentInfo(){
        if self.currentSeat != nil{
            self.infoTableView.hidden = false
            self.infoTableView.reloadData()
        }
        else{
            self.infoTableView.hidden = true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.seatView.flipSeats()
    }
    func seatAtIndexPath(indexPath:NSIndexPath) -> SeatButton{
        let seatButton = self.seatButtonArray[indexPath.section][indexPath.item]
        if self.seatHelper.seatArray[indexPath.section][indexPath.item] == nil{
            seatButton.exists = false
        }
        return seatButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func networkError() {
        
    }
    func tick(){
        seatHelper.updateSeatMapWithRoomId(self.courseHelper.getCurrentRoomId())
    }
    
    func numberOfColumns() -> Int {
        return seatHelper.columns
    }
    
    func numberOfRows() -> Int {
        return seatHelper.rows
    }

    
    func seatSelected() {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.infoTableView.dequeueReusableCellWithIdentifier("MyCell")!
        if self.currentSeat == nil{
            return cell
        }
        if let student = self.studentHelper.studentDict[self.currentSeat!.currentStudentId]{
            switch indexPath.row{
            case 0:
                cell.textLabel?.text = "座位"
                cell.detailTextLabel!.text = "\(self.currentSeat!.row)排\(self.currentSeat!.column)号"
            case 1:
                cell.textLabel?.text = "姓名"
                cell.detailTextLabel!.text = "\(student.name)"
            case 2:
                cell.textLabel?.text = "学号"
                cell.detailTextLabel!.text = "\(student.studentId)"
            case 3:
                break
            case 4:
                break
            case 5:
                break
            default:
                break
            }

        }
        return cell
    }
    

}
