//
//  NetworkManager.swift
//  iQuiz
//
//  Created by Jessica Wang on 5/20/25.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool = true
    var connectionStatusChanged: ((Bool) -> Void)?
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected = isConnected
            DispatchQueue.main.async {
                self?.connectionStatusChanged?(isConnected)
            }
        }
        monitor.start(queue: queue)
    }
    
    func fetchQuizzes(from urlString: String, completion: @escaping (Result<[QuizTopic], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let quizzes = try decoder.decode([QuizTopicDTO].self, from: data)
                let mappedQuizzes = quizzes.map { $0.toDomain() }
                DispatchQueue.main.async {
                    completion(.success(mappedQuizzes))
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case noConnection
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received"
        case .noConnection:
            return "No internet connection"
        }
    }
}

struct QuizTopicDTO: Codable {
    let title: String
    let desc: String
    let questions: [QuestionDTO]
    
    func toDomain() -> QuizTopic {
        let imageName: String
        switch title.lowercased() {
        case let name where name.contains("marvel"):
            imageName = "marvel"
        case let name where name.contains("math"):
            imageName = "math"
        case let name where name.contains("science"):
            imageName = "science"
        default:
            imageName = title.lowercased()
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "!", with: "")
        }
        
        return QuizTopic(
            title: title,
            description: desc,
            imageName: imageName,
            questions: questions.map { $0.toDomain() }
        )
    }
}

struct QuestionDTO: Codable {
    let text: String
    let answer: String
    let answers: [String]
    
    func toDomain() -> Question {
        let correctIndex = (Int(answer) ?? 1) - 1
        return Question(
            text: text,
            answers: answers,
            correctAnswerIndex: correctIndex
        )
    }
} 
