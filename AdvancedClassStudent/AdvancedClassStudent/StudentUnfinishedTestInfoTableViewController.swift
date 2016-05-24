import UIKit

class StudentUnfinishedTestInfoTableViewController: UITableViewController{
    @IBOutlet weak var testTypeLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var endsOnLabel: UILabel!
    @IBOutlet weak var beginsOnLabel: UILabel!
    @IBOutlet weak var messageText: UITextField!
    weak var test = StudentTestHelper.defaultHelper.currentTest
    weak var testHelper = StudentTestHelper.defaultHelper
    
    override func viewDidLoad() {
        let timeLimit = self.test!.timeLimit.toTimeString(false)
        self.timeLimitLabel.text = timeLimit == "" ? "无" : timeLimit
        let e = self.test!.expiresOn
        self.endsOnLabel.text = e == "" ? "无" : e
        self.beginsOnLabel.text = self.test!.beginsOn
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.test!.taken{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.showHudWithText("正在获取")
        self.testHelper?.getQuestionsInUntakenTest(self.test!){
            error in
            if let error = error{
                self.showError(error)
            }
            else{
                self.hideHud()
                 self.performSegueWithIdentifier("TakeTest", sender: self)
            
            }
        }
       
    }

}