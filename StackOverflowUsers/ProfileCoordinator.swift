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
    var navigationController: UINavigationController { get set }
    func start()
}

class ProfileCoordinator: NSObject, CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    private weak var viewController: ProfileListViewController?
    
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
