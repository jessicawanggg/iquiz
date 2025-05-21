import Foundation

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
    
    var isAnsweredCorrectly: Bool = false
    var selectedAnswerIndex: Int?
    
    init(text: String, answers: [String], correctAnswerIndex: Int) {
        self.text = text
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
    }
}

struct QuizTopic {
    let title: String
    let description: String
    let imageName: String
    var questions: [Question]
    var currentQuestionIndex: Int = 0
    var score: Int = 0
    
    var isFinished: Bool {
        return currentQuestionIndex >= questions.count
    }
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    mutating func answerCurrentQuestion(with index: Int) {
        guard var question = currentQuestion else { return }
        question.selectedAnswerIndex = index
        question.isAnsweredCorrectly = index == question.correctAnswerIndex
        if question.isAnsweredCorrectly {
            score += 1
        }
        questions[currentQuestionIndex] = question
    }
    
    mutating func moveToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    var progress: String {
        return "\(currentQuestionIndex + 1) of \(questions.count)"
    }
    
    var finalScore: String {
        return "\(score) of \(questions.count) correct"
    }
    
    var performanceDescription: String {
        let percentage = Double(score) / Double(questions.count)
        switch percentage {
        case 1.0:
            return "Perfect!"
        case 0.8..<1.0:
            return "Almost Perfect!"
        case 0.6..<0.8:
            return "Good Job!"
        default:
            return "Keep Practicing!"
        }
    }
} 