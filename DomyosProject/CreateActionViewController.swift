//
//  CreateActionViewController.swift
//  DomyosProject
//
//  Created by dib 258 on 21/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class CreateActionViewController: UIViewController {

    private struct Constants {
        static let UnwindeSegue: String = "unwind segue"
        static let TitlePlaceHolder: String = "Titre de l'exercice"
        static let DescriptionPlaceHolder: String = "Description de l'exercice"
        static let DurationPlaceHolder: String = "Duree en seconde de l'exercice"
        static let Rouge: String = "Rouge"
        static let Bleu: String = "Bleu"
        static let Vert: String = "Vert"
        static let Jaune: String = "Jaune"
        static let Blanc: String = "Blanc"
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
    
    @IBOutlet weak var bleuButton: UIButton!
    @IBOutlet weak var jauneButton: UIButton!
    @IBOutlet weak var blancButton: UIButton!
    @IBOutlet weak var rougeButton: UIButton!
    @IBOutlet weak var vertButton: UIButton!
    
    
    var action: ActionExercice? {
        didSet {
            updateUI()
        }
    }
    

    var ttfObserver: NSObjectProtocol!
    var detfObserver: NSObjectProtocol!
    var dutfObserver: NSObjectProtocol!
    var lastButton: UIButton!
    var isModified = false
    
    // MARK: Lifecycle
    
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
    
    // MARK: - Storyboard Action

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
                // Maybe an alert to slide sec, min, hours
                if let dur = self.dureeTextField.text.toInt() {
                    action.duration = dur
                }
            }
        }
        
    }
    
    // Update of the UI and set textField value
    func updateUI() {
        if action?.title == "" {
            titleTextField?.placeholder = Constants.TitlePlaceHolder
        } else {
            titleTextField?.text = action?.title
        }
        
        if action?.description == "" {
            descriptionTextField?.placeholder = Constants.DescriptionPlaceHolder
        } else {
            descriptionTextField?.text = action?.description
        }
        
        if action?.duration == 0 {
            dureeTextField?.placeholder = Constants.DurationPlaceHolder
        } else {
            dureeTextField?.text = "\(action!.duration)"
        }
        
        if let colorUnwrapped = action?.color {
            switch colorUnwrapped {
                case UIColor.redColor():
                    if let rouge = rougeButton {
                        setBorderColor(rougeButton)
                    }
                case UIColor.blueColor():
                    if let bleu = bleuButton  {
                        setBorderColor(bleuButton)
                    }
                case UIColor.yellowColor():
                    if let jaune = jauneButton {
                        setBorderColor(jauneButton)
                    }
                case UIColor.greenColor():
                    if let vert = vertButton {
                        setBorderColor(vertButton)
                    }
                case UIColor.whiteColor():
                    if let blanc = blancButton {
                        setBorderColor(blanc)
                    }
                
                default:
                    setBorderColor(blancButton)
                    action?.color = UIColor.whiteColor()
            }
        }
    }
    
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
    
    // MARK: - Actions
    
    @IBAction func selectColor(sender: UIButton) {
        setBorderColor(sender)
        
        if let text = sender.titleLabel?.text {
            switch text {
            case Constants.Rouge : action?.color = UIColor.redColor()
            case Constants.Bleu : action?.color = UIColor.blueColor()
            case Constants.Jaune : action?.color = UIColor.yellowColor()
            case Constants.Vert : action?.color = UIColor.greenColor()
            case Constants.Blanc : action?.color = UIColor.whiteColor()
            default : action?.color = UIColor.whiteColor()
            }
        }
    }
    
    @IBAction func confirmerButton(sender: AnyObject) {
        
    }
    
    @IBAction func annulerButton(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.UnwindeSegue {
            if let unwoundToMVC = segue.destinationViewController as? CreateExerciceTableViewController {
                unwoundToMVC.createNewAction(segue)
            }
        }
    }
}


extension CreateActionViewController: UITextFieldDelegate  {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
