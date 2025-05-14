//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Jessica Wang on 5/13/25.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!

    var quizTitle: String?
    var currentQuestion = 0
    var score = 0

    var questions: [String] = [
        "What is 2 + 2?",
        "What is the square root of 9?",
        "What is 10 / 2?"
    ]
    
    var answers: [[String]] = [
        ["3", "4", "5"],
        ["1", "3", "6"],
        ["2", "5", "10"]
    ]
    
    var correctAnswers = [1, 1, 1]
    var selectedAnswerIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = quizTitle
        setupQuestion()
        addGestureRecognizers()
    }

    func setupQuestion() {
        questionLabel.text = questions[currentQuestion]
        selectedAnswerIndex = nil

        let currentAnswers = answers[currentQuestion]
        let buttons = [answer1Button, answer2Button, answer3Button]
        
        for (index, button) in buttons.enumerated() {
            button?.setTitle(currentAnswers[index], for: .normal)
            button?.backgroundColor = .systemBackground
            button?.setTitleColor(.label, for: .normal)
        }
    }

    @IBAction func answerTapped(_ sender: UIButton) {
        let buttons = [answer1Button, answer2Button, answer3Button]
        for (index, button) in buttons.enumerated() {
            if sender == button {
                selectedAnswerIndex = index
                button?.backgroundColor = .systemBlue
                button?.setTitleColor(.white, for: .normal)
            } else {
                button?.backgroundColor = .systemBackground
                button?.setTitleColor(.label, for: .normal)
            }
        }
    }

    @IBAction func submitTapped(_ sender: Any) {
        guard let selected = selectedAnswerIndex else { return }
        performSegue(withIdentifier: "showAnswer", sender: selected)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnswer",
           let destination = segue.destination as? AnswerViewController,
           let selected = sender as? Int {
            destination.questionText = questions[currentQuestion]
            destination.correctAnswer = answers[currentQuestion][correctAnswers[currentQuestion]]
            destination.userAnswer = answers[currentQuestion][selected]
            destination.isCorrect = selected == correctAnswers[currentQuestion]
            destination.currentQuestion = currentQuestion
            destination.score = selected == correctAnswers[currentQuestion] ? score + 1 : score
            destination.totalQuestions = questions.count
            destination.quizTitle = quizTitle

            destination.questions = questions
            destination.answers = answers
            destination.correctAnswers = correctAnswers
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
        submitTapped(self)
    }

    @objc func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}
