import UIKit

class QuestionViewController: UIViewController {
    var quizTopic: QuizTopic!
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.isEnabled = false
        return button
    }()
    
    private var answerButtons: [UIButton] = []
    private var selectedAnswerIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        displayCurrentQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(progressLabel)
        view.addSubview(questionLabel)
        view.addSubview(stackView)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            questionLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // Add a tooltip to show swipe gestures are available
        let tooltipLabel = UILabel()
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        tooltipLabel.text = "Tip: Swipe right to submit, swipe left to exit quiz"
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
    
    private func displayCurrentQuestion() {
        guard let question = quizTopic.currentQuestion else { return }
        
        questionLabel.text = question.text
        progressLabel.text = quizTopic.progress
        
        // Clear existing buttons
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        answerButtons.removeAll()
        
        // Create new answer buttons
        for (index, answer) in question.answers.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(answer, for: .normal)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.cornerRadius = 8
            button.tag = index
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            answerButtons.append(button)
        }
        
        selectedAnswerIndex = nil
        submitButton.isEnabled = false
    }
    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        answerButtons.forEach { button in
            button.backgroundColor = .clear
            button.setTitleColor(.systemBlue, for: .normal)
        }
        
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
        
        selectedAnswerIndex = sender.tag
        submitButton.isEnabled = true
    }
    
    @objc private func submitButtonTapped() {
        submitAnswer()
    }
    
    @objc private func handleSwipeRight() {
        if submitButton.isEnabled {
            submitAnswer()
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
    
    private func submitAnswer() {
        guard let selectedAnswerIndex = selectedAnswerIndex else { return }
        
        quizTopic.answerCurrentQuestion(with: selectedAnswerIndex)
        
        let answerVC = AnswerViewController()
        answerVC.quizTopic = quizTopic
        navigationController?.pushViewController(answerVC, animated: true)
    }
} 