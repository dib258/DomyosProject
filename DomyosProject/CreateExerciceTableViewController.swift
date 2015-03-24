//
//  CreateExerciceTableViewController.swift
//  DomyosProject
//
//  Created by dib 258 on 20/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class CreateExerciceTableViewController: UITableViewController, UITextFieldDelegate {
    
    var exercice: Exercice?
    
    //var actions = [ActionExercice]()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Storyboard Actions
    
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
            titleTextField.placeholder = "Nom de votre Exercice"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if exercice != nil {
            // bug bizarre, ne veut pas prendre la valeur du textfield directement
            exercice!.title = textField.text
        }
        
        return true
    }
    
    @IBAction func createNewAction(segue: UIStoryboardSegue) {
        println("someone unwound back to me")
        if segue.identifier == Constants.UnwoundedSegue {
            if let svc = segue.sourceViewController as? CreateActionViewController {
                if exercice?.actions.last !== svc.action {
                    exercice?.actions.append(svc.action)
                }
            }
        }

    }
    
    // MARK: - Navigation
    
    private struct Constants {
        static let NextStepSegue: String = "CreateNewStep"
        static let UnwoundedSegue: String = "unwind segue"
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.NextStepSegue {
            if let cavc = segue.destinationViewController.contentViewController as? CreateActionViewController {

//                let action = ActionExercice()
//
//                cavc.action = action
                
//                exercice?.actions.append(action)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return exercice != nil ? exercice!.actions.count : 0
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Action"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = exercice?.actions[indexPath.row].title
        cell.detailTextLabel?.text = exercice?.actions[indexPath.row].description

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController
        } else {
            return self
        }
    }
}
