//
//  TaskTableViewCell.swift
//  7xTime
//
//  Created by 崔宇 on 15/3/4.
//  Copyright (c) 2015年 崔宇. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var textFieldForTitle: UILabel! = UILabel()
    var mPriorityLabel: UILabel! = UILabel()
    var mCheckButton : UIButton! = UIButton()
    
    var cheked : Bool?
    var section : Int?
    var indexPath : NSIndexPath!
    var dataForCell : TaskCellData?

    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var personButton: UIButton!
    @IBOutlet weak var mPeopleLabel: UILabel!
    @IBOutlet weak var mPeopleLabelValue: UILabel!
    
    var hideButton = true
    
    override func awakeFromNib() {
        textFieldForTitle.frame = CGRectMake(15, 5, 270, 30)
        mPriorityLabel.frame = CGRectMake(285, 5, 30, 30)
        mCheckButton.frame = CGRectMake(330, 5, 30, 30)
        mCheckButton.setTitle("X", forState: .Normal)
        mCheckButton.backgroundColor = UIColor.grayColor()
        mPriorityLabel.backgroundColor = UIColor.redColor()
        self.addSubview(mPriorityLabel)
        self.addSubview(textFieldForTitle)
        self.addSubview(mCheckButton)
        mCheckButton.addTarget(self, action: "clickCheckButton:", forControlEvents: .TouchUpInside)
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideButton(hideButton : Bool) {
        if hideButton {
            priorityButton.hidden = true
            categoryButton.hidden = true
            dateButton.hidden = true
            informationButton.hidden = true
            personButton.hidden = true
            mPeopleLabel.hidden = true
            mPeopleLabelValue.hidden = true
        } else {
            priorityButton.hidden = false
            categoryButton.hidden = false
            dateButton.hidden = false
            informationButton.hidden = false
            personButton.hidden = false
            mPeopleLabelValue.hidden = false
            mPeopleLabel.hidden = false
        }
    }
    
    func loadCell(indexPathForCell : NSIndexPath, dataForCell : TaskCellData) {
        self.dataForCell = dataForCell
        self.indexPath = indexPathForCell
        self.textFieldForTitle.text = dataForCell.valueForKey("title") as? String
        var priority = NSString(format: "%d", dataForCell.valueForKey("priority") as! Int!)
        println(priority)
        self.mPriorityLabel.text = priority as String
        self.mPriorityLabel.textAlignment = .Center
        var people = dataForCell.valueForKey("people") as! String?
        if (people != nil) {
            self.mPeopleLabelValue.text = people
        } else {
            self.mPeopleLabelValue.text = "Me"
        }
        self.section = indexPathForCell.section
        if self.section == 3 {
            self.cheked = true
        } else {
            self.cheked = false
        }
    }
}


protocol CheckDelegate: NSObjectProtocol {
    func clickCheckButton(button: UIButton)
}
