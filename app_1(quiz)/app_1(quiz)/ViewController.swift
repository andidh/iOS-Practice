//
//  ViewController.swift
//  app_1(quiz)
//
//  Created by Dehelean Andrei on 7/9/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var answerField: UITextField!
    
    let questions : [String] = ["What is the capital of Romania?",
                                "What is 8 + 8?",
                                "Are dolphins fish?"]
    
    let answers : [String] = ["Bucharest",
                              "16",
                              "No"]
    
    var questionCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questionLabel.text = questions[questionCount]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showNextQuestion(sender: UIButton) {
        questionCount += 1
        if questionCount == questions.count {
            questionCount = 0
        }
        self.questionLabel.text = questions[questionCount]
        self.result.text = ""
    }

    @IBAction func answerQuestion(sender: UIButton) {
        let answer = answerField.text
        if answer == answers[questionCount]{
            result.text = "Correct"
            result.textColor = UIColor.greenColor()
        } else {
            result.text = "Incorrect"
            result.textColor = UIColor.redColor()
        }
    }
}

