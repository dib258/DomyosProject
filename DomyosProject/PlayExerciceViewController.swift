//
//  ViewController.swift
//  DomyosProject
//
//  Created by dib 258 on 09/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class PlayExerciceViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIBarButtonItem!
    @IBOutlet weak var pauseBtn: UIBarButtonItem!
    
    var exercice: Exercice?
    
    var timer = NSTimer()
    var counter : Int = 0
    var isCounting = false
    var id_current = 0
    var currentAction : ActionExercice?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let backgroundImage = UIImage(named: "background")?.CGImage
        //backgroundImage?.stretchableImageWithLeftCapWidth(0, topCapHeight: 0)
        
        //self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        if exercice != nil {
            self.title = exercice!.title
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isCounting == true {
            timer.invalidate()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isCounting == true {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
        }
    }

    // MARK: Storyboard actions
    
    @IBAction func clearButton(sender: AnyObject) {
        isCounting = false
        timer.invalidate()
        counter = 0
        id_current = 0

    }
    
    @IBAction func playButton(sender: AnyObject) {
        if isCounting == false {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
            isCounting = true
        }
    }
    
    @IBAction func pauseButton(sender: AnyObject) {
        if isCounting == true {
            timer.invalidate()
            isCounting = false
        }
        
    }
    
    // MARK: Methods that run the player
    
    // Func that transform second to human readable time
    func secondFormatToHours(var newTime: Double) -> String {
        let total_seconds = Int(newTime)
        
        let seconds = total_seconds % 60
        let total_minutes = total_seconds / 60
        let minutes = total_minutes % 60
        let total_hours = total_minutes / 60
        let hours = total_hours % 24

        
        var retour = ""
        
        if total_hours > 0 {
            retour += "\(hours) h"
        }
        
        if total_minutes > 0 {
            retour += "\(minutes) min"
        }
        
        retour += "\(seconds) sec"
        
        println(retour)
        return retour

    }
    
    // Func called each time the timer ticks
    func updateCounter() {
        if let action = currentAction {
            
            ++counter
            
            if action.duration - counter <= 0 {
                getNextActionExercice()
            }
            
            timeLabel.text = secondFormatToHours(Double(action.duration - counter))
        } else {
            setFirstAction()
            updateCounter()
        }
    }
    
    // Func that set the first Action of the exercice
    func setFirstAction() {
        if let actions = exercice?.actions {
            if !actions.isEmpty {
                id_current = 0
                currentAction = actions[id_current]
                
                titleLabel.text = currentAction!.title
                descriptionLabel.text = currentAction!.description
                self.view.backgroundColor = currentAction!.color
            }
        }
    }
    
    // Func that retrieve the next Action of the exercice
    func getNextActionExercice() {
        if let actions = exercice?.actions {
            if !actions.isEmpty {
                if id_current+1 < actions.count {
                    currentAction = actions[++id_current]
                    
                    counter = 0
                    titleLabel.text = currentAction!.title
                    descriptionLabel.text = currentAction!.description
                    self.view.backgroundColor = currentAction!.color
                } else {
                    // Finish
                    timer.invalidate()
                    titleLabel.text = "Finished !"
                    descriptionLabel.text = ""
                    timeLabel.text = ""
                }
            }
        }
    }
    

}


