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
    
    //var arrayOfExercices = [ActionExercice]()
    
    var timer = NSTimer()
    var counter : Int = 0
    var isCounting = false
    var id_current = 0
    var currentAction : ActionExercice?

    
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
            
            // Hide the play button
            playBtn.enabled = false
            playBtn.tintColor = UIColor.clearColor()
            // Show the pause button
            pauseBtn.enabled = true
            pauseBtn.tintColor = nil
        }
    }
    
    @IBAction func pauseButton(sender: AnyObject) {
        if isCounting == true {
            timer.invalidate()
            isCounting = false
            
            // Show the play button
            playBtn.enabled = true
            playBtn.tintColor = nil
            // Hide the pause button
            pauseBtn.enabled = false
            pauseBtn.tintColor = UIColor.clearColor()
        }
        
    }
    
    func secondFormatToHours(var newTime: Double) -> String {
        let total_seconds = Int(newTime)
        
        let seconds = total_seconds % 60
        let total_minutes = total_seconds / 60
        let minutes = total_minutes % 60
        let total_hours = total_minutes / 60
        let hours = total_hours % 24
        
        println("total_seconds \(total_seconds) total_minutes \(total_minutes) total_hours \(total_hours)")
        
        return "\(hours)h \(minutes)min \(seconds)sec"

    }
    
    func updateCounter() {
        if let action = currentAction {
            
            ++counter
            
            if action.duration - counter <= 0 {
                getNextActionExercice()
            }
            
            //timeLabel.text = String(action.Duration - counter)
            timeLabel.text = secondFormatToHours(Double(action.duration - counter))
        } else {
            setFirstAction()
        }
    }
    
    func setFirstAction() {
        if let actions = exercice?.actions {
            if !actions.isEmpty {
                id_current = 0
                currentAction = actions[id_current]
            }
        }
    }
    
    func getNextActionExercice() {
        if let actions = exercice?.actions {
            if !actions.isEmpty {
                if id_current < actions.count {
                    currentAction = actions[id_current]
                    id_current++
                    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Default-Landscape@2x.png")!)

        if exercice != nil {
            self.title = exercice!.title
        }
    }
}


