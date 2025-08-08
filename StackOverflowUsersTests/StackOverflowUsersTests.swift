//
// 
// 

import Testing
import UIKit
@testable import StackOverflowUsers
import XCTest

struct StackOverflowUsersTests {

    struct TestUserModel: UserDataModel {
        var name: String = "John Doe"
        
        var reputation: Int = 112929239239
        
        var profileImageURL: String = "https://picsum.photos/200/300"
        
        
}

    @Test func testCastToViewModel() async throws {
        let userModel = TestUserModel()
        
        let viewModel = UserViewModel.fromDataModel(userModel)
        
        #expect(userModel.name == viewModel.name)
        #expect(userModel.profileImageURL == viewModel.imageURL)
        #expect(userModel.reputation == Int(viewModel.reputation))
        
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }


}
