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
    
    let quizzes: [Quiz] = [
        Quiz(title: "Mathematics", description: "Solve math problems", imageName: "math"),
        Quiz(title: "Marvel Superheroes", description: "Test your Marvel knowledge", imageName: "marvel"),
        Quiz(title: "Science", description: "Explore scientific facts", imageName: "science")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iQuiz"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = UIImage(named: quiz.imageName)
        return cell
    }
}
