//
//  ViewController.swift
//  ZXSlideMenuCell
//
//  Created by 葛枝鑫 on 15/9/25.
//  Copyright © 2015年 葛枝鑫. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  MyTableViewCellDelegate {
    
    //MARK: - Property
    var tableData: [String]? = ["cell 0", "cell 1", "cell 2", "cell 3", "cell 4","cell 5", "cell 6"]
    var openedCell: MyTableViewCell?

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addNewCell(sender: UIBarButtonItem) {
        let count = self.tableData?.count
        let title = "cell \(count!)"
        self.tableData?.append(title)
        self.tableView.reloadData()
    }

    //MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableData?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MyTableViewCell? = tableView.dequeueReusableCellWithIdentifier("MyTableViewCell") as? MyTableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("MyTableViewCell", owner: nil, options: nil).first as? MyTableViewCell
            cell?.delegate = self
        }
        let str = self.tableData![indexPath.row]
        cell!.myTitleLabel.text = str
        cell!.index = indexPath.row
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.closeOpenedCell()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.closeOpenedCell()
    }
    
    private func closeOpenedCell() {
        if let openedCell = self.openedCell {
            openedCell.colseMenu()
            self.openedCell = nil
            return
        }
    }
    
    //MARK: - Cell Delegate
    func slideMenuCellMenuOpened(cell: ZXSlideMenuCell) {
        self.openedCell = cell as? MyTableViewCell
    }
    
    func myTableViewCell(cell: MyTableViewCell, deleteBtnClicked:UIButton) {
        if let index = cell.index {
            self.tableData?.removeAtIndex(index)
            self.tableView.reloadData()
            cell.colseMenu()
        }
    }
}

