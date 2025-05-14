//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Jessica Wang on 5/13/25.
//

import UIKit

class AnswerViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    var questionText: String?
    var correctAnswer: String?
    var userAnswer: String?
    var isCorrect: Bool = false
    var currentQuestion: Int = 0
    var score: Int = 0
    var totalQuestions: Int = 0
    var quizTitle: String?

    var questions: [String] = []
    var answers: [[String]] = []
    var correctAnswers: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = quizTitle
        questionLabel.text = questionText
        correctAnswerLabel.text = "Correct Answer: \(correctAnswer ?? "")"
        resultLabel.text = isCorrect ? "Correct!" : "Incorrect"
        addGestureRecognizers()
    }

    @IBAction func continueTapped(_ sender: Any) {
        if currentQuestion + 1 < questions.count {
            if let questionVC = storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController {
                questionVC.quizTitle = quizTitle
                questionVC.questions = questions
                questionVC.answers = answers
                questionVC.correctAnswers = correctAnswers
                questionVC.currentQuestion = currentQuestion + 1
                questionVC.score = score
                navigationController?.pushViewController(questionVC, animated: true)
            }
        } else {
            performSegue(withIdentifier: "showFinished", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFinished",
           let destination = segue.destination as? FinishedViewController {
            destination.correct = score
            destination.total = totalQuestions
        }
    }

    func addGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @objc func handleSwipeRight() {
        continueTapped(self)
    }

    @objc func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}
