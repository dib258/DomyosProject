//
//  ListExerciceTableViewController.swift
//  DomyosProject
//
//  Created by dib 258 on 20/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class ListExerciceTableViewController: UITableViewController {

    var exercices = [Exercice]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cetvc = segue.destinationViewController as? CreateExerciceTableViewController {
            if segue.identifier == Constants.CreateNewExerciceSegue {
                let newExercice = Exercice()
            
                cetvc.exercice = newExercice
                
                exercices.append(newExercice)
            }
        }
        
        if let evc = segue.destinationViewController.contentViewController as? PlayExerciceViewController {
            if segue.identifier == Constants.PlayExerciceSegue {
                if let exerciceIndex = tableView.indexPathForSelectedRow()?.row {
                    println(" index : \(exerciceIndex)")
                    evc.exercice = exercices[exerciceIndex]
                }
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
        return exercices.count
    }

    private struct Constants {
        static let CellReuseIdentifier = "Exercice"
        static let CreateNewExerciceSegue = "CreateNewExercice"
        static let PlayExerciceSegue = "playExercice"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = exercices[indexPath.row].title
        cell.detailTextLabel?.text = "\(exercices[indexPath.row].duration)"

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

class ActionExercice {
    var duration : Int = 0
    var title : String = ""
    var description : String = ""
    var color : UIColor = UIColor.whiteColor()
}

class Exercice {
    var title: String = ""
    var actions: [ActionExercice] = [ActionExercice]()
    var duration: Int {
        get {
            var duree = 0
            for action in actions {
                duree += action.duration
            }
            return duree
        }
    }
}
