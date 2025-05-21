//
//  FinishedViewController.swift
//  iQuiz
//
//  Fixed by Jessica Wang on 5/20/25.
//

import UIKit

class FinishedViewController: UIViewController {
    var quizTopic: QuizTopic!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back to Topics", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        displayResults()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            backButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 200),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTapped))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let tooltipLabel = UILabel()
        tooltipLabel.translatesAutoresizingMaskIntoConstraints = false
        tooltipLabel.text = "Tip: Swipe left to return to topics"
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
    
    private func displayResults() {
        titleLabel.text = quizTopic.performanceDescription
        scoreLabel.text = quizTopic.finalScore
        
        if quizTopic.performanceDescription == "Perfect!" {
            showConfetti()
        }
    }
    
    private func showConfetti() {
        let confettiView = UIView(frame: view.bounds)
        view.addSubview(confettiView)
        view.sendSubviewToBack(confettiView)
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.center.x, y: -50)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let colors: [UIColor] = [.systemRed, .systemGreen, .systemBlue, .systemYellow, .systemPurple]
        
        let cells: [CAEmitterCell] = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 4
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = 180
            cell.velocityRange = 40
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scale = 0.3
            cell.scaleRange = 0.2
            cell.color = color.cgColor
            
            cell.contents = UIImage(systemName: "star.fill")?.cgImage
            return cell
        }
        
        emitter.emitterCells = cells
        confettiView.layer.addSublayer(emitter)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
} 
