//
//  File.swift
//  iQuiz
//
//  Created by Jessica Wang on 5/5/25.
//

import Foundation
import UIKit

struct Quiz {
    let title: String
    let description: String
    let imageName: String
}

class QuizListViewController: UITableViewController {
    
    let quizzes: [QuizTopic] = [
        QuizTopic(
            title: "Mathematics",
            description: "Test your math skills",
            imageName: "math",
            questions: [
                Question(
                    text: "What is 2 + 2?",
                    answers: ["3", "4", "5", "6"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What is 10 × 5?",
                    answers: ["40", "45", "50", "55"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "What is 100 ÷ 4?",
                    answers: ["20", "25", "30", "35"],
                    correctAnswerIndex: 1
                )
            ]
        ),
        QuizTopic(
            title: "Marvel Superheroes",
            description: "Test your Marvel knowledge",
            imageName: "marvel",
            questions: [
                Question(
                    text: "What is Iron Man's real name?",
                    answers: ["Tony Stark", "Steve Rogers", "Bruce Banner", "Peter Parker"],
                    correctAnswerIndex: 0
                ),
                Question(
                    text: "What is Thor's hammer called?",
                    answers: ["Stormbreaker", "Mjolnir", "Gungnir", "Vanir"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What metal is Captain America's shield made of?",
                    answers: ["Steel", "Adamantium", "Vibranium", "Titanium"],
                    correctAnswerIndex: 2
                )
            ]
        ),
        QuizTopic(
            title: "Science",
            description: "Explore scientific facts",
            imageName: "science",
            questions: [
                Question(
                    text: "What is the chemical symbol for gold?",
                    answers: ["Ag", "Fe", "Au", "Cu"],
                    correctAnswerIndex: 2
                ),
                Question(
                    text: "What planet is known as the Red Planet?",
                    answers: ["Venus", "Mars", "Jupiter", "Saturn"],
                    correctAnswerIndex: 1
                ),
                Question(
                    text: "What is the largest organ in the human body?",
                    answers: ["Heart", "Brain", "Liver", "Skin"],
                    correctAnswerIndex: 3
                )
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "iQuiz"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizCell")
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        let quiz = quizzes[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = quiz.title
        content.secondaryText = quiz.description
        content.image = UIImage(named: quiz.imageName)
        content.imageProperties.maximumSize = CGSize(width: 44, height: 44)
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var selectedQuiz = quizzes[indexPath.row]
        selectedQuiz.currentQuestionIndex = 0
        selectedQuiz.score = 0
        
        let questionVC = QuestionViewController()
        questionVC.quizTopic = selectedQuiz
        navigationController?.pushViewController(questionVC, animated: true)
    }
}
