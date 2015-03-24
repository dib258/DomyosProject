//
//  CreateActionViewController.swift
//  DomyosProject
//
//  Created by dib 258 on 21/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class CreateActionViewController: UIViewController, UITextFieldDelegate {

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
    
    var action: ActionExercice? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        observeTextField()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let observer = ttfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        
        if let observer = detfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        
        if let observer = dutfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        
    }
    
    // Update of the UI and set textField value
    func updateUI() {
        if action?.title == "" {
            titleTextField?.placeholder = "Titre de l'exercice"
        } else {
            titleTextField?.text = action?.title
        }
        
        if action?.description == "" {
            descriptionTextField?.placeholder = "Description de l'exercice"
        } else {
            descriptionTextField?.text = action?.description
        }
        
        if action?.duration == 0 {
            dureeTextField?.placeholder = "Duree en seconde de l'exercice"
        } else {
            dureeTextField?.text = "\(action?.duration)"
        }
    }
    
    // MARK: - Storyboard Action
    
    var ttfObserver: NSObjectProtocol?
    var detfObserver: NSObjectProtocol?
    var dutfObserver: NSObjectProtocol?
    
    // Observer for the textFields
    func observeTextField() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        
        ttfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: titleTextField, queue: queue) { notification in
            if let action = self.action {
                action.title = self.titleTextField.text
            }
        }
        
        detfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: descriptionTextField, queue: queue) { notification in
            if let action = self.action {
                action.description = self.descriptionTextField.text
            }
        }
        
        dutfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: dureeTextField, queue: queue) { notification in
            if let action = self.action {
                // TODO: check and force to put an int
                // Maybe an alert to slide sec, min, hours
                action.duration = self.dureeTextField.text.toInt()!
            }
        }
        
    }
    
    var lastButton: UIButton?
    
    func setBorderColor(button: UIButton) {
        if lastButton != nil {
            lastButton?.layer.borderWidth = 0
            lastButton?.layer.borderColor = UIColor.clearColor().CGColor
        }
        
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grayColor().CGColor
        
        lastButton = button
    }
    
    @IBAction func selectColor(sender: UIButton) {
        setBorderColor(sender)
        
        if let text = sender.titleLabel?.text {
            switch text {
                case "Rouge" : action?.color = UIColor.redColor()
                case "Bleu" : action?.color = UIColor.blueColor()
                case "Jaune" : action?.color = UIColor.yellowColor()
                case "Vert" : action?.color = UIColor.greenColor()
                case "Blanc" : action?.color = UIColor.whiteColor()
                default : action?.color = UIColor.whiteColor()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
//        println("Tag of the textfield \(textField.tag)")
//        
//        switch textField.tag {
//            case 1 : // Title
//                action?.title = textField.text
//            case 2 : // Description
//                action?.description = textField.text
//            case 3 : // Duree
//                if let duration = textField.text.toInt() {
//                    action?.duration = textField.text.toInt()!
//                } else {
//                    action?.duration = 0
//                }
//            
//            default : break
//        }
        
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
