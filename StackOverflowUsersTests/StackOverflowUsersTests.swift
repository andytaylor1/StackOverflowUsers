//
//
//

import Testing
import UIKit
@testable import StackOverflowUsers
import XCTest

struct StackOverflowUsersTests {
    
    class MockUserFollowingService: UserFollowingService {
        private var followingDict: [String: Bool] = [:]
        override func isFollowing(userName: String) -> Bool {
            followingDict[userName] ?? false
        }
        override func setFollowing(_ following: Bool, for userName: String) {
            followingDict[userName] = following
        }
        override func toggleFollowing(for userName: String) -> Bool {
            let newValue = !(followingDict[userName] ?? false)
            followingDict[userName] = newValue
            return newValue
        }
    }
    
    struct TestUserModel: UserDataModel {
        var name: String = "John Doe"
        
        var reputation: Int = 112929239239
        
        var profileImageURL: String = "https://picsum.photos/200/300"
        
    }
    
    @Test func testIntegration_UserViewModelAndService() async throws {
        
        let service = MockUserFollowingService()
        let user1 = TestUserModel(name: "Alice", reputation: 100, profileImageURL: "url1")
        let user2 = TestUserModel(name: "Bob", reputation: 200, profileImageURL: "url2")
        let vm1 = UserViewModel.fromDataModel(user1, userFollowingService: service)
        let vm2 = UserViewModel.fromDataModel(user2, userFollowingService: service)
        
        // Initial state
        #expect(vm1.isFollowing == false)
        #expect(vm2.isFollowing == false)
        
        // Toggle user1
        vm1.toggleFollowing()
        #expect(vm1.isFollowing == true)
        #expect(vm2.isFollowing == false)
        
        // Toggle user2
        vm2.toggleFollowing()
        #expect(vm1.isFollowing == true)
        #expect(vm2.isFollowing == true)
        
        // Toggle user1 again
        vm1.toggleFollowing()
        #expect(vm1.isFollowing == false)
        #expect(vm2.isFollowing == true)
        
        // Edge case: unusual user name
        let user3 = TestUserModel(name: "", reputation: 0, profileImageURL: "url3")
        let vm3 = UserViewModel.fromDataModel(user3, userFollowingService: service)
        #expect(vm3.isFollowing == false)
        vm3.toggleFollowing()
        #expect(vm3.isFollowing == true)
    }
    
    @Test func testCastToViewModel() async throws {
        let userModel = TestUserModel()
        let mockService = MockUserFollowingService()
        let viewModel = UserViewModel.fromDataModel(userModel, userFollowingService: mockService)
        #expect(userModel.name == viewModel.name)
        #expect(userModel.profileImageURL == viewModel.imageURL)
        #expect(userModel.reputation == Int(viewModel.reputation))
        // Test following logic
        #expect(viewModel.isFollowing == false)
        viewModel.toggleFollowing()
        #expect(viewModel.isFollowing == true)
        viewModel.toggleFollowing()
        #expect(viewModel.isFollowing == false)
    }
    
    
}
