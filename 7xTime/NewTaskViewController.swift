//
//  NewTaskViewController.swift
//  7xTime
//
//  Created by 崔宇 on 15/3/2.
//  Copyright (c) 2015年 崔宇. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var mTitleTextField: UITextField!
    @IBOutlet weak var mPriorityPickerView: UIPickerView!
    @IBOutlet weak var mPeopleTextField: UITextField!
    @IBOutlet weak var notificationLabel: UILabel!
    var taskTitle : String?
    var taskPriority : Int?
    var taskPeople : String?
    var priorityArray = ["1","2","3"]
    var date : NSDate?
    var taskSection : Int?
    var sectionData : CoreDataHelper?
    
    override func viewDidLoad() {
        mTitleTextField.delegate = self
        mPeopleTextField.delegate = self
        mPriorityPickerView.delegate = self
        mPriorityPickerView.dataSource = self
        mTitleTextField.tag = 0
        mPeopleTextField.tag = 1
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "addNewTask:")

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if !textField.text.isEmpty {
        switch textField.tag {
        case 0:
            taskTitle = textField.text
        case 1:
            taskPeople = textField.text
        default:
            return
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return priorityArray[row]
    }
    
    func addNewTask(button : UIBarButtonItem) {
        taskTitle = mTitleTextField.text
        taskPeople = mPeopleTextField.text
        println(self.taskSection)
        if mTitleTextField.text.isEmpty {
            mTitleTextField.placeholder = "Input Task Title"
            notificationLabel.text = "Before done, Please input title or back"
            // 自动换行
            notificationLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            notificationLabel.numberOfLines = 0
            // 自动居中
            notificationLabel.textAlignment = NSTextAlignment.Center
        } else {
            var priorityRow = mPriorityPickerView.selectedRowInComponent(0)
            self.taskPriority = priorityArray[priorityRow].toInt()
            self.date = NSDate()
            println("__________________________")
            println(taskPeople)
            println(date)
            println(taskTitle)
            println(taskPriority)
            var row = 0
            sectionData?.insertDataToTaskCellData(taskPeople, time: date, title: taskTitle!, priority: taskPriority, section: taskSection!, row :row)
            self.navigationController?.popToRootViewControllerAnimated(false)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
