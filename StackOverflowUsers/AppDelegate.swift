//
// 
// 

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var users: [UserDataModel] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let url = URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow") {
            fetchUser(from: url) { result in
                switch result {
                case .success(let users):
                    self.users = users
                    print("Users stored: \(self.users)")
                case .failure(let failure):
                    print("Failed: \(failure)")
                }
            }
        }
        
        return true
    }
    
    private func fetchUser(from url: URL, completion: @escaping ((Result<[UserDataModelResponse], Error>) -> Void)) {
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data,
                response,
                error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.zeroByteResource)))
                    return
                }
                
                do {
                    let userResponse = try JSONDecoder().decode(
                        UserResponse.self,
                        from: data
                    )
                    let users = userResponse.items
                    completion(.success(users))
                } catch {
                    completion(.failure(error))
                }
            })
            
        task.resume()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//"https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow"
