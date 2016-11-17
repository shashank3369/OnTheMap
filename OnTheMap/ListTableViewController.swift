//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Kothapalli on 11/14/16.
//  Copyright © 2016 Kothapalli. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    var studentList: [StudentInformation]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            guard error == nil else {
                print ("failure")
                return
            }
            self.studentList = studentInfo
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            guard error == nil else {
                print ("failure")
                return
            }
            self.studentList = studentInfo
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.studentList != nil) {
            return (self.studentList?.count)!
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableCell", for: indexPath) as! ListTableViewCell

        guard let firstName = self.studentList?[indexPath.row].firstName else {
            return cell
        }
        
        guard let lastName = self.studentList?[indexPath.row].lastName else {
            return cell
        }
        cell.nameLabel.text = "\(firstName) \(lastName)"
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlString = self.studentList?[indexPath.row].mediaURL else {
            return
        }
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    

}
