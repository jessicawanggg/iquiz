//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Jessica Wang on 5/20/25.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewController(_ controller: SettingsViewController, didUpdateQuizzes quizzes: [QuizTopic])
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "Quiz Data URL:"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter URL"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .URL
        return textField
    }()
    
    private let refreshIntervalLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto-refresh Interval (seconds):"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let refreshIntervalTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter interval (0 to disable)"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let checkNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
        setupNetworkMonitoring()
    }
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        
        [urlLabel, urlTextField, refreshIntervalLabel, refreshIntervalTextField, checkNowButton, activityIndicator].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        checkNowButton.addTarget(self, action: #selector(checkNowTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    private func loadSettings() {
        urlTextField.text = SettingsManager.shared.quizURL
        if SettingsManager.shared.refreshInterval > 0 {
            refreshIntervalTextField.text = String(Int(SettingsManager.shared.refreshInterval))
        }
    }
    
    private func setupNetworkMonitoring() {
        NetworkManager.shared.connectionStatusChanged = { [weak self] isConnected in
            self?.checkNowButton.isEnabled = isConnected
            if !isConnected {
                self?.showNetworkAlert()
            }
        }
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
    
    @objc private func checkNowTapped() {
        guard NetworkManager.shared.isConnected else {
            showNetworkAlert()
            return
        }
        
        activityIndicator.startAnimating()
        checkNowButton.isEnabled = false
        
        NetworkManager.shared.fetchQuizzes(from: SettingsManager.shared.quizURL) { [weak self] result in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.checkNowButton.isEnabled = true
            
            switch result {
            case .success(let quizzes):
                SettingsManager.shared.lastRefreshDate = Date()
                self.delegate?.settingsViewController(self, didUpdateQuizzes: quizzes)
                self.showSuccessAlert()
                
            case .failure(let error):
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    @objc private func saveTapped() {
        if let url = urlTextField.text, !url.isEmpty {
            SettingsManager.shared.quizURL = url
        }
        
        if let intervalText = refreshIntervalTextField.text,
           let interval = Double(intervalText) {
            SettingsManager.shared.refreshInterval = interval
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Quiz data updated successfully!",
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
} 
