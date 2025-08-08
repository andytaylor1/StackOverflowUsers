//
// 
// 

import UIKit

/// Indicates the states the view can be in.
enum ViewState {
    case loading
    case loaded([UserViewModel])
    case error(Error)
}

/// Protocol for the coordinator pattern used in the project.
protocol CoordinatorProtocol: AnyObject {
    /// The navigation controller for the coordinator to use.
    var navigationController: UINavigationController { get set }
    
    /// Starts the view loading process.
    func start()
}

/// Coordincator for handling viewing user profiles.
class ProfileCoordinator: NSObject, CoordinatorProtocol {
    
    /// The navigation controller handling the user view.
    var navigationController: UINavigationController
    
    private weak var viewController: ProfileListViewController?
    
    /// Initialiser for profile coordinator
    /// - Parameter navigationController: The navigation controller for the coordinator to use.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CollectionView") as? ProfileListViewController else { fatalError("Missing Storyboard Setup") }
        
        vc.coordinator = self
        viewController = vc
        
        navigationController.pushViewController(vc, animated: false)
        vc.viewState = .loading
        
        fetchUsers()
        
    }
    
    private func fetchUsers() {
    let dg = DispatchGroup()
     let dataLoader = DataLoader()
        dataLoader.fetchUser { [weak self] result in
        guard let self else { return }
            switch result {
            case .success(let success):
                let viewModels = success.map { UserViewModel.fromDataModel($0) }
                
                var viewModelsWithImage: [UserViewModel] = []
                viewModels.forEach { model in
                    dg.enter()
                    dataLoader.getImage(from: URL(string: model.imageURL)!) { image in
                    var viewModel = model
                        if let image = image {
                        viewModel.profileImage = image
                            viewModelsWithImage.append(viewModel)
                        }
                        dg.leave()
                    }
                }
                dg.notify(queue: .main) {
                    self.viewController?.viewState = .loaded(viewModelsWithImage)
                }
            case .failure(let failure):
                self.viewController?.viewState = .error(failure)
            }
        }
    }
    

}
