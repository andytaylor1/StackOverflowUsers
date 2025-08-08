//
//
//
import UIKit

/// Loads the data needed from the api.
class DataLoader {
    
    /// The url used to obtain data needed.
    let url  = URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow")
    
    /// Fetches the users from the api.
    /// - Parameter completion: Called when the user data has been obtained or failed.
    func fetchUser(completion: @escaping ((Result<[UserDataModelResponse], Error>) -> Void)) {
        let task = URLSession.shared.dataTask(
            with: url!,
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
    
    /// Gets the associated image from the given url.
    /// - parameters:
    /// - url: the url the image is located.
    /// - completion: called when the url has either loaded or failed to load. If failed nil will be returned.
    func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
