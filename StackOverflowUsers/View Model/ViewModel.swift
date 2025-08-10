import UIKit
/// View model for a user.
struct UserViewModel: Hashable {
    
    /// Name of the user.
    var name: String
    /// Reputation of the user.
    var reputation: String
    /// Image url for the user.
    var imageURL: String
    /// Profile Image of the user.
    var profileImage: UIImage?
    /// Indicates if the user is being followed (persisted locally).
    var following: String {
        isFollowing ? "Yes" : "No"
    }

    private let userFollowingService: UserFollowingService

    // Indicates the following status for the user.
    var isFollowing: Bool {
        userFollowingService.isFollowing(userName: name)
    }

    /// Initialiser for user view model.
    /// - parameters:
    ///   - name: Name of the user.
    ///   - reputation: Reputation of the user.
    ///   - imageURL: Image url of the user.
    ///   - userFollowingService: Service for following state.
    init(name: String, reputation: Int, imageURL: String, userFollowingService: UserFollowingService) {
        self.name = name
        self.reputation = "\(reputation)"
        self.imageURL = imageURL
        self.profileImage = nil
        self.userFollowingService = userFollowingService
    }

    /// Toggle following state and persist it
    func toggleFollowing() {
        _ = userFollowingService.toggleFollowing(for: name)
    }
    
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        lhs.name == rhs.name &&
        lhs.reputation == rhs.reputation &&
        lhs.imageURL == rhs.imageURL
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(reputation)
        hasher.combine(imageURL)
    }
    
}

extension UserViewModel {
    
    /// Generates a user view model from the given user data model.
    static func fromDataModel(_ user: UserDataModel, userFollowingService: UserFollowingService) -> UserViewModel {
        return UserViewModel(
            name: user.name,
            reputation: user.reputation,
            imageURL: user.profileImageURL,
            userFollowingService: userFollowingService
        )
    }
}
