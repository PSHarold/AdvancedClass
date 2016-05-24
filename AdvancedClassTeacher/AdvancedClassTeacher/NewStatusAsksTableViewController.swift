

import UIKit

class NewStatusAsksTableViewController: UITableViewController {

    let me = TeacherAuthenticationHelper.defaultHelper.me
    var selectedAsk: AskForLeave!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(NewStatusAskTableViewCell.self, forCellReuseIdentifier: "cell")
        let xib = UINib(nibName: "NewStatusAskTableViewCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "cell")
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.me.pendingCount == 0{
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            self.tableView.reloadData()
        }
        
    }

   

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return me.pendingCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewStatusAskTableViewCell
        let ask = self.me.pendingAsks[indexPath.row]
        let course = self.me.courseDict[ask.courseId]
        if let course = course{
            cell.courseName = course.name
            cell.timeString = "第\(ask.weekNo)周 周\(ask.dayNo) 第\(ask.periodNo)节"
            cell.studentString = ask.studentId
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let askViewerController = self.storyboard!.instantiateViewControllerWithIdentifier("PendingAskTableViewController") as! PendingAskTableViewController
        askViewerController.ask = self.me.pendingAsks[indexPath.row]
        self.navigationController?.pushViewController(askViewerController, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowAsk"{
            let vc = segue.destinationViewController as! PendingAskTableViewController
            vc.ask = self.selectedAsk
        }
    }
    
    
   
}
