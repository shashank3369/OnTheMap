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
                self.showError(errorString: "Not able to load student information.")
                return
            }
            self.studentList = studentInfo
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        setupNavBar()
    }

    func setupNavBar() {
        self.parent?.navigationItem.hidesBackButton = true
        self.parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        let newStudent = UIBarButtonItem(image: UIImage(named: "pin"), style: .plain, target: self, action: #selector(addStudent))
        self.parent?.navigationItem.setRightBarButtonItems([refreshButton,newStudent], animated: false)
        self.parent?.navigationItem.title = "On The Map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            guard error == nil else {
                self.showError(errorString: "Cannot load student information.")
                return
            }
            self.studentList = studentInfo
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
            self.showError(errorString: "No url for the student exists")
            return
        }
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func logout () {
        OTMClient.sharedInstance().deleteSession { (success, error) in
            guard error == nil else {
                self.showError(errorString: "Not able to logout")
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            }
        }
    }
    
    func reload() {
        OTMClient.sharedInstance().getStudentInfo() {(studentInfo, error) in
            guard error == nil else {
                self.showError(errorString: "Having trouble refreshing student information.")
                return
            }
            self.studentList = studentInfo
            self.tableView.reloadData()
        }
    }
    
    func addStudent() {
        self.performSegue(withIdentifier: "addStudentInfoFromList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addStudentInfoFromList" {
            let destinationNav = segue.destination as! UINavigationController
            let destinationVC = destinationNav.topViewController as! InformationPostingViewController
            destinationVC.identifiyingProperty = "list"
        }
    }
    
    func showError(errorString: String) {
        let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {}
}
