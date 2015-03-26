//
//  CreateExerciceTableViewController.swift
//  DomyosProject
//
//  Created by dib 258 on 20/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class CreateExerciceTableViewController: UITableViewController, UITextFieldDelegate {
    private struct Constants {
        static let NextStepSegue: String = "CreateNewStep"
        static let UnwoundedSegueToExercice: String = "UnwindSegueToExercice"
        static let ModifyStepSegue: String = "ModifyStep"
        static let CellReuseIdentifier = "Action"
        static let titlePlaceHolder = "Nom de votre Exercice"
    }
    
    var exercice: Exercice?
    
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
            titleTextField.placeholder = Constants.titlePlaceHolder
        }
    }

    // MARK: - LifeCycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start observing change in the TextField
        observeTextField()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // remove the observer when the view is not on screen
        if let observer = ttfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }

    // MARK: - Storyboard Actions
    
    var ttfObserver: NSObjectProtocol?
    
    // Func to observer change in the TextField
    func observeTextField() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        
        ttfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: titleTextField, queue: queue) { notification in
            if let exercice = self.exercice {
                exercice.title = self.titleTextField.text
            }
        }
    }
    
    // Resign the keyboard when hit the return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Func called from the CreateActionViewController with unwinded segue
    @IBAction func createNewAction(segue: UIStoryboardSegue) {
        if segue.identifier == Constants.UnwoundedSegueToExercice {
            if let svc = segue.sourceViewController as? CreateActionViewController {
                if svc.isModified == false {
                    if exercice?.actions.last !== svc.action {
                        exercice?.actions.append(svc.action!)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.NextStepSegue {
            if let cavc = segue.destinationViewController.contentViewController as? CreateActionViewController {
                cavc.action = ActionExercice()
            }
        } else if segue.identifier == Constants.ModifyStepSegue {
            if let cavc = segue.destinationViewController.contentViewController as? CreateActionViewController {
                if let actionIndex = tableView.indexPathForSelectedRow()?.row {
                    cavc.isModified = true
                    cavc.action = exercice?.actions[actionIndex]
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercice != nil ? exercice!.actions.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = exercice?.actions[indexPath.row].title
        cell.detailTextLabel?.text = exercice?.actions[indexPath.row].description

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            exercice?.actions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

// Extension to access via segue the next controller event if there is a Navigation Controller between
extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController
        } else {
            return self
        }
    }
}
