//
//  AnswerViewController.swift
//  iQuiz
//
//  Fixed by Jessica Wang on 5/20/25.
//

import UIKit

class AnswerViewController: UIViewController {
    var quizTopic: QuizTopic!
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let correctAnswerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        displayAnswer()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        view.addSubview(questionLabel)
        view.addSubview(resultLabel)
        view.addSubview(correctAnswerLabel)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resultLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            correctAnswerLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 40),
            correctAnswerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            correctAnswerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: correctAnswerLabel.bottomAnchor, constant: 40),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextButtonTapped))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let tooltipLabel = UILabel()
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        tooltipLabel.text = "Tip: Swipe right for next question, swipe left to exit quiz"
        tooltipLabel.textAlignment = .center
        tooltipLabel.font = .systemFont(ofSize: 12)
        tooltipLabel.textColor = .gray
        view.addSubview(tooltipLabel)
        
        NSLayoutConstraint.activate([
            tooltipLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            tooltipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tooltipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func displayAnswer() {
        guard let question = quizTopic.currentQuestion else { return }
        
        questionLabel.text = question.text
        
        if question.isAnsweredCorrectly {
            resultLabel.text = "Correct! 🎉"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "Incorrect"
            resultLabel.textColor = .systemRed
        }
        
        correctAnswerLabel.text = "Correct answer: \(question.answers[question.correctAnswerIndex])"
    }
    
    @objc private func nextButtonTapped() {
        quizTopic.moveToNextQuestion()
        
        if quizTopic.isFinished {
            let finishedVC = FinishedViewController()
            finishedVC.quizTopic = quizTopic
            navigationController?.pushViewController(finishedVC, animated: true)
        } else {
            let questionVC = QuestionViewController()
            questionVC.quizTopic = quizTopic
            navigationController?.pushViewController(questionVC, animated: true)
        }
    }
    
    @objc private func handleSwipeLeft() {
        let alert = UIAlertController(title: "Exit Quiz?", 
                                    message: "Your progress will be lost.", 
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
} 
