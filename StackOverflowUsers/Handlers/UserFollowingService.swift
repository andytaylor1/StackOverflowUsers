import Foundation

/// Service responsible for persisting and retrieving the following state for users.
final class UserFollowingService {
    
    private func followingKey(for userName: String) -> String {
        return "following_\(userName)"
    }
    
    func isFollowing(userName: String) -> Bool {
        UserDefaults.standard.bool(forKey: followingKey(for: userName))
    }
    
    func setFollowing(_ following: Bool, for userName: String) {
        UserDefaults.standard.set(following, forKey: followingKey(for: userName))
    }
    
    func toggleFollowing(for userName: String) -> Bool {
        let current = isFollowing(userName: userName)
        let newValue = !current
        setFollowing(newValue, for: userName)
        return newValue
    }
}
