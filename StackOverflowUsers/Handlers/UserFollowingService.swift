import Foundation

/// Service responsible for persisting and retrieving the following state for users.
class UserFollowingService {
    
    private func followingKey(for userName: String) -> String {
        return "following_\(userName)"
    }
    
    /// Returns the stored following status for the given username.
    func isFollowing(userName: String) -> Bool {
        UserDefaults.standard.bool(forKey: followingKey(for: userName))
    }
    
    /// Sets the following status to be stored for persistance.
    func setFollowing(_ following: Bool, for userName: String) {
        UserDefaults.standard.set(following, forKey: followingKey(for: userName))
    }
    
    /// Toggle the following status for the given user,
    func toggleFollowing(for userName: String) -> Bool {
        let current = isFollowing(userName: userName)
        let newValue = !current
        setFollowing(newValue, for: userName)
        return newValue
    }
}
