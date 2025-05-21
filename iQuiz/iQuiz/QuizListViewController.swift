//
//  QuizListViewController.swift
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

class QuizListViewController: UITableViewController, SettingsViewControllerDelegate {
    private var quizzes: [QuizTopic] = []
    private var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        setupNetworkMonitoring()
        loadQuizzes()
        startRefreshTimer()
    }
    
    private func setupUI() {
        title = "iQuiz"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuizCell")
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshQuizzes), for: .valueChanged)
    }
    
    private func setupNetworkMonitoring() {
        NetworkManager.shared.connectionStatusChanged = { [weak self] isConnected in
            if !isConnected {
                self?.showNetworkAlert()
            }
        }
    }
    
    private func loadQuizzes() {
        guard NetworkManager.shared.isConnected else {
            showNetworkAlert()
            return
        }
        
        NetworkManager.shared.fetchQuizzes(from: SettingsManager.shared.quizURL) { [weak self] result in
            switch result {
            case .success(let quizzes):
                self?.quizzes = quizzes
                self?.tableView.reloadData()
                SettingsManager.shared.lastRefreshDate = Date()
                
            case .failure(let error):
                self?.showErrorAlert(message: error.localizedDescription)
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    private func startRefreshTimer() {
        refreshTimer?.invalidate()
        
        let interval = SettingsManager.shared.refreshInterval
        guard interval > 0 else { return }
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.loadQuizzes()
        }
    }
    
    @objc private func refreshQuizzes() {
        loadQuizzes()
    }
    
    @objc func showSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func showNetworkAlert() {
        let alert = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func settingsViewController(_ controller: SettingsViewController, didUpdateQuizzes quizzes: [QuizTopic]) {
        self.quizzes = quizzes
        tableView.reloadData()
        startRefreshTimer()
    }
    
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
