//
//  TaskTableViewController.swift
//  7xTime
//
//  Created by 崔宇 on 15/2/25.
//  Copyright (c) 2015年 崔宇. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    var sectionData = CoreDataHelper()
    var textFieldToNewTask = UITextField()
    var selectIndexPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionData.insertDataToSection(0, title: "Todo")
        sectionData.insertDataToSection(1, title: "Doing")
        sectionData.insertDataToSection(2, title: "Done")
                sectionData.insertDataToTaskCellData("Cui Yu", time: NSDate(), title: "First Task 1", priority: 1, section: 0, row: 0)
                sectionData.insertDataToTaskCellData("Cui Yu", time: NSDate(), title: "First Task 1", priority: 1, section: 1, row: 0)
                sectionData.insertDataToTaskCellData("Cui Yu", time: NSDate(), title: "First Task 1", priority: 1, section: 2, row: 0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        self.tableView.estimatedRowHeight = 44.0;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        println(sectionData.getSectionsFromSql())
        return sectionData.getSectionsFromSql().count
    }
    
    //    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        var sectionNumber = sectionData.getSectionsFromSql().objectAtIndex(section).name
    //        return sectionData.getSectionNameFromSql(sectionNumber)
    //    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var count = sectionData.getNumberOfRowsInSection(section)
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TaskTableViewCell {
        var nib : UINib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "taskTableViewCellIndentifier")
        let cell = tableView.dequeueReusableCellWithIdentifier("taskTableViewCellIndentifier", forIndexPath: indexPath) as! TaskTableViewCell
        let section = indexPath.section
        var dataForCell = sectionData.getDataOfCell(indexPath) as? TaskCellData
        cell.loadCell(indexPath, dataForCell: dataForCell!)
        cell.textFieldForTitle.text = cell.dataForCell?.valueForKey("title") as? String
        if (selectIndexPath != nil) {
            if (selectIndexPath == indexPath) {
                cell.hideButton = false
            } else {
                cell.hideButton = true
            }
        } else {
            cell.hideButton = true
        }
        var hideButtonForCell : Bool = cell.hideButton
        cell.hideButton(hideButtonForCell)
        
        // Configure the cell...
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view : UIView = UIView(frame: CGRectMake(0, 0, 280, 30))
        var label : UILabel = UILabel()
        var sectionNumber = sectionData.getSectionsFromSql().objectAtIndex(section).name
        label.backgroundColor = UIColor.redColor()
        label.text = sectionData.getSectionNameFromSql(sectionNumber)
        label.textColor = UIColor.blackColor()
        // set the label frame or it will be not shown in the view
        label.frame = CGRectMake(0, 0, 280, 30)
        var button : UIButton = UIButton.buttonWithType(.System) as! UIButton
        button.frame = CGRectMake(290, 0, 40, 30)
        button.setTitle("Add", forState: .Normal)
        button.tag = section
        button.addTarget(self, action: "addNewTask:", forControlEvents: .TouchUpInside)
        view.addSubview(label)
        view.addSubview(button)
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectIndexPath != indexPath {
            if selectIndexPath != nil {
                var oldSelectIndexPath = selectIndexPath!
                selectIndexPath = indexPath
                tableView.reloadRowsAtIndexPaths([indexPath,oldSelectIndexPath], withRowAnimation: .None)
            }
            selectIndexPath = indexPath
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        } else {
            selectIndexPath = nil
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete {
            return
        }
        
        sectionData.deleteDataFromSQL(indexPath)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (selectIndexPath != nil) {
            if (selectIndexPath == indexPath) {
                return 84
            } else {
                return 40
            }
        }
        return 40
    }
    
    func taskCellForRowAtIndexPath(indexPath : NSIndexPath) -> TaskTableViewCell {
        return self.tableView.cellForRowAtIndexPath(indexPath) as! TaskTableViewCell
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var fromRow = fromIndexPath.row
        var toRow = toIndexPath.row
        var fromSection = fromIndexPath.section
        var toSection = toIndexPath.section
        println("-------------------------------")
        println(fromRow)
        println(toRow)
        println(fromSection)
        println(toSection)
        println("-------------------------------")
        
        if fromSection != toSection {
            var iSection = -1
            var modifyISectionString = NSString(format: "row == %d AND section == %d", fromRow, fromSection)
            sectionData.modifyDataInSQL("section", queryString: modifyISectionString, newValue: iSection)
            sectionData.updateRowInSection(fromIndexPath, insert: false)
            sectionData.updateRowInSection(toIndexPath, insert: true)
            var modifySectionString = NSString(format: "row == %d AND section == %d", fromRow, iSection)
            sectionData.modifyDataInSQL("row", queryString: modifySectionString, newValue: toRow)
            
            var modifyRowString = NSString(format: "row == %d AND section == %d", toRow, iSection)
            sectionData.modifyDataInSQL("section", queryString: modifyRowString, newValue: toSection)
        } else {
            var iRow = -1
            var modifyFromRowString = NSString(format: "row == %d AND section == %d", fromRow, fromSection)
            sectionData.modifyDataInSQL("row", queryString: modifyFromRowString, newValue: iRow)
            sectionData.updateRowInSection(fromIndexPath, insert: false)
            sectionData.updateRowInSection(toIndexPath, insert: true)
            var modifyToRowString = NSString(format: "row == %d AND section == %d", iRow, fromSection)
            sectionData.modifyDataInSQL("row", queryString: modifyToRowString, newValue: toRow)
        }
    }
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func addNewTask(button : UIButton) {
        var storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        // get the data through the tag of button
        var newTaskView : NewTaskViewController = storyBoard.instantiateViewControllerWithIdentifier("NewTaskView") as! NewTaskViewController
        newTaskView.taskSection = button.tag
        // Must modify the same taskSection(Core Data), or it will be merge confick.
        newTaskView.sectionData = self.sectionData
        self.navigationController?.pushViewController(newTaskView, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    //    func addNewTask(taskName : NSString, time : NSDate, people : NSString, priority : NSInteger) {
    //        tableView.beginUpdates()
    //        sectionData.insertDataToTaskCellData(people, time: time, title: taskName, priority: priority, section: 2)
    //        let targetIndexPath = NSIndexPath(forRow: sectionData.getNumberOfRowsInSection(2) - 1, inSection: 2)
    //        tableView.insertRowsAtIndexPaths([targetIndexPath], withRowAnimation: .Automatic)
    //        tableView.endUpdates()
    //    }
}
