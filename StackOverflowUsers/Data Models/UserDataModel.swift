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
