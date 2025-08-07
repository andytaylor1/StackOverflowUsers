import Foundation
import UIKit

/// Data model for a user.
protocol UserDataModel {

    /// Name of the user.
    var name: String { get }
    /// Reputation of the user.
    var reputation: Int { get }
    /// Profile Image URL of the user.
    var profileImageURL: String { get }
    
}

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

struct UserResponse: Decodable {
    var items: [UserDataModelResponse]
}

/// View model for a user.
class UserViewModel {

    /// Name of the user.
    var name: String
    /// Reputation of the user.
    var repuation: Int
    /// Profile Image of the user.
    var profileImage: UIImage
     /// Indicates if the user is being followed.
    var following: Bool
    
    /// Initialiser for user view model.
    init(name: String, repuation: Int, profileImage: UIImage, following: Bool) {
        self.name = name
        self.repuation = repuation
        self.profileImage = profileImage
        self.following = following
    }
    
}

extension UserViewModel {

    /// Generates a user view model from the given user data model.
    static func fromDataModel(_ user: UserDataModel) -> UserViewModel {
        return UserViewModel(
            name: user.name,
            repuation: user.reputation,
            profileImage: getImageFromURL(string: user.profileImageURL),
            following: false
            )
    }
    
    private static func getImageFromURL(string: String) -> UIImage {
        
        return UIImage()
        
    }
}
