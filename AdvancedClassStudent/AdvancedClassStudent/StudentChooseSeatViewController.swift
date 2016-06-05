//
//  StudentChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentChooseSeatViewController: UIViewController, SeatViewDataSource, SeatViewDelegate, UIPopoverPresentationControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate{
    var searchBarScopes = ["学号", "姓名"]
    var timer:NSTimer!
    var seatButtonDict = Dictionary<String,SeatButton>()
    var popoverViewController: StudentInfoPopoverTableViewController!
    var myPopoverPresentationController: UIPopoverPresentationController!
    let hud = MBProgressHUD()
    var currentSeatLocation: SeatLocation?{
        didSet{
            self.freeButton.enabled = self.currentSeatLocation != nil
        }
    }
    
    deinit{
        print("choose seat deinited")
    }
    @IBOutlet weak var seatView:SeatView!
    @IBOutlet weak var flipBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var freeButton: UIBarButtonItem!
    var resultsTableViewController: StudentSeatSearchResultTableViewController!
    var filteredStudentIds: [String]!

    
    var searchBar: UISearchBar{
        get{
            return self.searchController.searchBar
        }
    }
    
    var searchController: UISearchController!
    
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None 
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.freeButton.enabled = false
        seatView.delegate = self
        seatView.dataSource = self
        self.setupSearchBar()
        self.popoverViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentInfo") as! StudentInfoPopoverTableViewController
        
        self.myPopoverPresentationController = UIPopoverPresentationController(presentedViewController: self.popoverViewController, presentingViewController: self)
        self.popoverViewController.preferredContentSize = CGSizeMake(150, 100)
        
                        //self.timer = NSTimer(timeInterval: 5.0, target: self, selector: "tick", userInfo: nil, repeats: true)
       // NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        self.popoverViewController.modalPresentationStyle = .Popover
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        print(self.seatView.frame)
        super.viewDidDisappear(true)
        self.timer?.invalidate()
        self.resultsTableViewController = nil
        self.popoverViewController = nil
        self.myPopoverPresentationController = nil
        
    }
    
    
    
    
    func numberOfColumns() -> Int {
        return StudentSeatHelper.defaultHelper.columns
    }
    
    func numberOfRows() -> Int {
        return StudentSeatHelper.defaultHelper.rows
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    
    
    
    func setupSearchBar(){
        resultsTableViewController = StudentSeatSearchResultTableViewController()
        resultsTableViewController.extendedLayoutIncludesOpaqueBars = true
        
        resultsTableViewController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchBar.scopeButtonTitles = self.searchBarScopes
        searchBar.placeholder = "寻找同学"
        
    }
    
    
    @IBAction func showSearchBar(sender: UIBarButtonItem) {
        self.presentViewController(self.searchController, animated: true, completion: nil)
        self.searchBarButton.enabled = false
    }
    
    
    
    func hideSearchBar() {
        searchBar.resignFirstResponder()
        self.searchBarButton.enabled = true
    }
    
    func filterStudentIds(){
        let searchText = searchBar.text ?? ""
        self.filteredStudentIds = []
        if searchText != ""{
            let course = StudentCourse.currentCourse
            if self.searchBar.selectedScopeButtonIndex == 0{
                for studentId in course.students.keys{
                    if studentId != StudentAuthenticationHelper.defaultHelper.me.studentId && studentId.containsString(searchText){
                        self.filteredStudentIds.append(studentId)
                    }
                }
            }
            else{
                for student in course.students.values{
                    if student.studentId != StudentAuthenticationHelper.defaultHelper.me.studentId && student.name.containsString(searchText){
                        self.filteredStudentIds.append(student.studentId)
                    }
                }
            }
        }
        self.resultsTableViewController.studentIds = self.filteredStudentIds
        self.resultsTableViewController.tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterStudentIds()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterStudentIds()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.hideSearchBar()
    }

    @IBAction func freeSeat(sender: UIBarButtonItem) {
        if let location = self.currentSeatLocation{
            self.showHudWithText("正在释放座位")
            StudentSeatHelper.defaultHelper.freeSeat(location){
                (error, seatStatus) in
                
                if let error = error{
                    self.showError(error)
                    if error == CError.NETWORK_ERROR{
                        self.hideHud()
                        return
                    }
                    return
                }
                if seatStatus == .Empty{
                    self.currentSeatLocation = nil
                }
                self.seatView.changeSeatStatusAtLocation(location, seatStatus: seatStatus)
                self.hideHud()
            }
        }
    }
    
    func didSelectSeatAtLocation(location: SeatLocation, seatButton: SeatButton) {
        
        let seat = StudentSeatHelper.defaultHelper.seatArray[location.rowForArray][location.colForArray]!
        switch seat.status{
        case .Checked:
            self.showHudWithText("正在释放座位")
            StudentSeatHelper.defaultHelper.freeSeat(location){
                (error, seatStatus) in
                
                if let error = error{
                    self.showError(error)
                    if error == CError.NETWORK_ERROR{
                        self.hideHud()
                        return
                    }
                    return
                }
                if seatStatus == .Empty{
                    self.currentSeatLocation = nil
                }
                self.seatView.changeSeatStatusAtLocation(location, seatStatus: seatStatus)
                self.hideHud()
            }

        
        case .Empty:
            
            if self.currentSeatLocation != nil{
                self.showHudWithText("请先释放座位", mode: .Text, hideAfter: 0.5)
                return
            }
            self.showHudWithText("正在锁定座位")
            StudentSeatHelper.defaultHelper.chooseSeat(location){
                (error, seatStatus) in
                defer { self.seatView.changeSeatStatusAtLocation(location, seatStatus: seatStatus) }
                if let error = error{
                    self.showError(error)
                    return
                }
                if seatStatus == .Checked{
                    self.currentSeatLocation = location
                }
                self.hideHud()
            }
        case .Taken:
            let studentId = seat.currentStudentId
            let course = StudentCourse.currentCourse
            if let pop = self.popoverViewController.popoverPresentationController{
                pop.permittedArrowDirections = .Any
                pop.delegate = self
                pop.sourceView = seatButton
                pop.sourceRect = seatButton.bounds
            }
            self.hideHud()
            self.popoverViewController.student = course.students[studentId]
            self.presentViewController(self.popoverViewController, animated: true, completion: nil)
            
        default:
            return
        }

    }

    func seatStatusAtLocation(location:SeatLocation) -> SeatStatus{
        let status = StudentSeatHelper.defaultHelper.getSeatAtLocation(location).status
        if status == .Checked{
            self.currentSeatLocation = location
        }
        return status
    }

    @IBAction func flipSeatMap(sender: UIBarButtonItem) {
        self.seatView.flipSeats()
    }
    
    
    @IBAction func refreshSeatMap(sender: UIBarButtonItem) {
        self.showHudWithText("正在刷新")
        StudentSeatHelper.defaultHelper.getSeatMap{
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
            }
            else{
                self.seatView.reloadSeats()
                self.hideHud()
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtLocation indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        
    }

}
