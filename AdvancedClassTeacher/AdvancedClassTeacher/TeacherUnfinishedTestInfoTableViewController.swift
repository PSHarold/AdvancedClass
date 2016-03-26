import UIKit

class TeacherUnfinishedTestInfoTableViewController: UITableViewController{
    @IBOutlet weak var testTypeLabel: UILabel!
    @IBOutlet weak var finishedCountLabel: UILabel!
    @IBOutlet weak var endsOnLabel: UILabel!
    @IBOutlet weak var beginsOnLabel: UILabel!
    @IBOutlet weak var messageText: UITextField!
    weak var test = TeacherTestHelper.defaultHelper.currentTest
    weak var testHelper = TeacherTestHelper.defaultHelper
    
    override func viewDidLoad() {
        self.testTypeLabel.text = self.test!.testTypeEnum.description
        self.finishedCountLabel.text = "\(self.test!.finishedCount)"
        let e = self.test!.expiresOn
        self.endsOnLabel.text = e == "" ? "无" : e
        self.beginsOnLabel.text = self.test!.beginsOn
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2{
            self.testHelper!.endTest(self.test!){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }

}