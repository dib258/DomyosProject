//
//  CreateActionViewController.swift
//  DomyosProject
//
//  Created by dib 258 on 21/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class CreateActionViewController: UIViewController, UITextFieldDelegate {

    var action: ActionExercice = ActionExercice()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Storyboard Action
    
    @IBAction func selectColor(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            switch text {
                case "Rouge" : action.color = UIColor.redColor()
                case "Bleu" : action.color = UIColor.blueColor()
                case "Jaune" : action.color = UIColor.yellowColor()
                case "Vert" : action.color = UIColor.greenColor()
                case "Blanc" : action.color = UIColor.whiteColor()
                default : action.color = UIColor.whiteColor()
            }
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            descriptionTextField.delegate = self
        }
    }
    
    @IBOutlet weak var dureeTextField: UITextField! {
        didSet {
            dureeTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        println("Tag of the textfield \(textField.tag)")
        
        switch textField.tag {
            case 1 : // Title
                action.title = textField.text
            case 2 : // Description
                action.description = textField.text
            case 3 : // Duree
                if let duration = textField.text.toInt() {
                    action.duration = textField.text.toInt()!
                } else {
                    action.duration = 0
                }
            
            default : break
        }
        
        return true
    }
    
    @IBAction func confirmerButton(sender: AnyObject) {
        
    }
    
    @IBAction func annulerButton(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.unwindSegue {
            if let unwoundToMVC = segue.destinationViewController as? CreateExerciceTableViewController {
                unwoundToMVC.createNewAction(segue)
            }
        }
    }
    
    private struct Constants {
        static let unwindSegue: String = "unwind segue"
    }

}
