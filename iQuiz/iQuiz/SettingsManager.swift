import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let quizURL = "quiz_url"
        static let refreshInterval = "refresh_interval"
        static let lastRefreshDate = "last_refresh_date"
    }
    
    var quizURL: String {
        get {
            return defaults.string(forKey: Keys.quizURL) ?? "http://tednewardsandbox.site44.com/questions.json"
        }
        set {
            defaults.set(newValue, forKey: Keys.quizURL)
        }
    }
    
    var refreshInterval: TimeInterval {
        get {
            return defaults.double(forKey: Keys.refreshInterval)
        }
        set {
            defaults.set(newValue, forKey: Keys.refreshInterval)
        }
    }
    
    var lastRefreshDate: Date? {
        get {
            return defaults.object(forKey: Keys.lastRefreshDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: Keys.lastRefreshDate)
        }
    }
    
    var shouldRefresh: Bool {
        guard let lastRefresh = lastRefreshDate,
              refreshInterval > 0 else { return true }
        
        return Date().timeIntervalSince(lastRefresh) >= refreshInterval
    }
    
    private init() {}
} 