//
// 
// 

import XCTest
@testable import StackOverflowUsers

struct TestUserModel: UserDataModel {
    var name: String = "John Doe"
    
    var reputation: Int = 112929239239
    
    var profileImageURL: String = "https://picsum.photos/200/300"
}

final class StackOverflowUsersTest: XCTestCase {


    func testImageLoads() throws {
        let expectation = XCTestExpectation(description: "Load image.")
        
        let userModel = TestUserModel()
        let dataLoader = DataLoader()
        dataLoader.getImage(from: URL(string: userModel.profileImageURL)!) { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

}
