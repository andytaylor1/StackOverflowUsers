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

struct StoredDataModel: UserDataModel, Hashable {

    var id: UUID
    var name: String
    var reputation: Int
    var profileImageURL: String
    
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
struct UserViewModel: Hashable {    
    
    /// Name of the user.
    var name: String
    /// Reputation of the user.
    var reputation: String
    
    var imageURL: String
    /// Profile Image of the user.
    var profileImage: UIImage?
     /// Indicates if the user is being followed.
    var following: String
    
    /// Initialiser for user view model.
    init(name: String, reputation: Int, imageURL: String, following: Bool) {
        self.name = "Name: \(name)"
        self.reputation = "Reputation: \(reputation)"
        self.imageURL = imageURL
        self.following = "following: \(following ? "Yes" : "No")"
    }
    
}

extension UserViewModel {

    /// Generates a user view model from the given user data model.
    static func fromDataModel(_ user: UserDataModel) -> UserViewModel {
    let viewModel = UserViewModel(
            name: user.name,
            reputation: user.reputation,
            imageURL: user.profileImageURL,
            following: false,
        )
        return viewModel
    }
    
    
}
