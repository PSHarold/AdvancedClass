//
//  StudentChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherSeatViewController: UIViewController, SeatViewDataSource, SeatViewDelegate, UIPopoverPresentationControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate{
    
    
    var searchBarScopes = ["学号", "姓名"]
    
    
    var seatHelper = TeacherSeatHelper.defaultHelper
    var timer: NSTimer!
    var seatButtonDict = Dictionary<String,SeatButton>()
    var popoverViewController: StudentInfoPopoverTableViewController!
    var myPopoverPresentationController: UIPopoverPresentationController!
    let hud = MBProgressHUD()
    var currentSeatIndex: NSIndexPath?
    weak var courseHelper = TeacherCourseHelper.defaultHelper
    @IBOutlet weak var seatView:SeatView!
    @IBOutlet weak var flipBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    var lock = false
    var resultsTableViewController: TeacherSeatSearchTableViewController!
    var filteredStudentIds: [String]!
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    var searchBar: UISearchBar{
        get{
            return self.searchController.searchBar
        }
    }
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        
        
        self.setupSearchBar()
        
        seatView.delegate = self
        seatView.dataSource = self
        self.popoverViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentInfo") as! StudentInfoPopoverTableViewController
        
        self.myPopoverPresentationController = UIPopoverPresentationController(presentedViewController: self.popoverViewController, presentingViewController: self)
        self.popoverViewController.preferredContentSize = CGSizeMake(150, 100)
        
                        //self.timer = NSTimer(timeInterval: 5.0, target: self, selector: "tick", userInfo: nil, repeats: true)
       // NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        self.popoverViewController.modalPresentationStyle = .Popover
    }
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    
    
    
    func setupSearchBar(){
        resultsTableViewController = TeacherSeatSearchTableViewController()
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
        searchBar.placeholder = "寻找学生"
        
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
            let course = TeacherCourse.currentCourse
            if self.searchBar.selectedScopeButtonIndex == 0{
                for studentId in course.students.keys{
                    if studentId.containsString(searchText){
                        self.filteredStudentIds.append(studentId)
                    }
                }
            }
            else{
                for student in course.students.values{
                    if student.name.containsString(searchText){
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

 

    
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        print(self.seatView.frame)
        super.viewDidDisappear(true)
        self.timer?.invalidate()
    }
    
    func numberOfColumns() -> Int {
        return self.seatHelper.columns
    }
    
    func numberOfRows() -> Int {
        return self.seatHelper.rows
    }
    
    
    
    func didSelectSeatAtIndexPath(indexPath: NSIndexPath, seatButton: SeatButton) {
        
        let seat = self.seatHelper.seatArray[indexPath.row][indexPath.section]!
        switch seat.status{
        case .Taken:
            let studentId = seat.currentStudentId
            let course = TeacherCourse.currentCourse
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

    func seatStatusAtIndexPath(indexPath:NSIndexPath) -> SeatStatus{
        let status = self.seatHelper.getSeatAtIndexPath(indexPath).status
        if status == .Checked{
            self.currentSeatIndex = indexPath
        }
        return status
    }

    @IBAction func flipSeatMap(sender: UIBarButtonItem) {
        self.seatView.flipSeats()
    }
    
    
    @IBAction func refreshSeatMap(sender: UIBarButtonItem) {
        self.showHudWithText("正在刷新", mode: .Indeterminate)
        self.seatHelper.getSeatMap{
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        if let seat = self.seatHelper.seatToLocate{
//            let frame = self.seatView.getSeatCenterPointAtIndexPath(NSIndexPath(forRow: seat.row, inSection: seat.column), toView: self.view)
//            self.seatView.scrollView.setContentOffset(frame.origin, animated: true)
//        }
        
        
    }
}
