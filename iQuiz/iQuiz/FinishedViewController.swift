//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Jessica Wang on 5/13/25.
//

import UIKit

class FinishedViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    var total: Int = 0
    var correct: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if correct == total {
            resultLabel.text = "Perfect! You got \(correct) of \(total)."
        } else if correct > total / 2 {
            resultLabel.text = "Almost! You got \(correct) of \(total)."
        } else {
            resultLabel.text = "Keep practicing! You got \(correct) of \(total)."
        }
    }

    @IBAction func backToListTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
