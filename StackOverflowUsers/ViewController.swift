//
// 
// 

import UIKit

enum ViewState {
    case loading
    case loaded([UserViewModel])
    case error(Error)
}

protocol CoordinatorProtocol: AnyObject {
    var viewState: ViewState { get set }
}

class Coordinator: NSObject, CoordinatorProtocol {
    var viewState: ViewState = .loading
}

class ViewController: UITableViewController {

    var coordinator: Coordinator? = Coordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow") {
            fetchUser(from: url) { [weak self] usersResult in
                switch usersResult {
                case .success(let users):
                    let usersViewModels = users.map {
                        UserViewModel.fromDataModel($0)
                    }
                    self?.coordinator?.viewState = .loaded(usersViewModels)
                case .failure(let error):
                    self?.coordinator?.viewState = .error(error)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
     private func fetchUser(from url: URL, completion: @escaping ((Result<[UserDataModelResponse], Error>) -> Void)) {
         coordinator?.viewState = .loading
         tableView.reloadData()
         
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch coordinator?.viewState {
            case .loading:
                return 1
            case .loaded(let users):
                return users.count
            case .error(_):
                return 1
            case nil:
                return 0
            }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch coordinator?.viewState {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Loading", for: indexPath)
            return cell
        case .loaded(let users):
            let user = users[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile", for: indexPath)
            return cell
        case .error(let message):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Error", for: indexPath)
            return cell
        case nil:
            return UITableViewCell()
        }
    }


}
