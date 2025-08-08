import Foundation
import UIKit

/// Data model pattern for a user.
protocol UserDataModel {
    
    /// Name of the user.
    var name: String { get }
    /// Reputation of the user.
    var reputation: Int { get }
    /// Profile Image URL of the user.
    var profileImageURL: String { get }
    
}

/// The expected data model repsonse from the api.
struct UserDataModelResponse: UserDataModel, Decodable {
    
    var name: String
    
    var reputation: Int
    
    var profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case name = "display_name"
        case reputation
        case profileImageURL = "profile_image"
    }
    
}

/// The expected initial repsonse for the api containing the users to display.
struct UserResponse: Decodable {
    var items: [UserDataModelResponse]
}

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
