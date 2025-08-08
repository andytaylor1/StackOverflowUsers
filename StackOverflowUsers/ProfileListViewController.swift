//
// 
//
import UIKit

class ProfileListViewController: UICollectionViewController {
    
    enum Section {
    case main
    case loading
    case error
    }
    
    enum Item: Hashable {
    case loading(UUID)
    case card(UserViewModel)
    case error(UUID)
    }
    
    var viewState: ViewState? {
        didSet {
            switch viewState {
            case .loading:
                 var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                 snapshot.deleteAllItems()
                snapshot.appendSections([.loading])
                snapshot.appendItems([.loading(UUID())])
                dataSource?.apply(snapshot, animatingDifferences: true)
                
            case .loaded(let users):
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapshot.deleteAllItems()
                snapshot.appendSections([.main])
                let cards = users.map { Item.card($0) }
                snapshot.appendItems(cards)
                dataSource?.apply(snapshot, animatingDifferences: true)

            case .error(_):
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                 snapshot.deleteAllItems()
                snapshot.appendSections([.error])
                snapshot.appendItems([.error(UUID())])
                dataSource?.apply(snapshot, animatingDifferences: true)
                break
            case nil:
                break
            }
        }
    }
    
    var coordinator: ProfileCoordinator?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = makeCardLayout()
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            switch model {
            case .card(let model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Profile", for: indexPath) as! ProfileListCell
                cell.profileLabel.text = model.name
                cell.reputationLabel.text = "\(model.reputation)"
                cell.imageView.image = model.profileImage
                cell.layer.cornerRadius = 12
                cell.layer.masksToBounds = true
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowRadius = 4
                return cell
            case .loading(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Loading", for: indexPath) as! UICollectionViewListCell
                cell.layer.cornerRadius = 12
                cell.layer.masksToBounds = true
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowRadius = 4
                return cell
            case .error(_):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Error", for: indexPath) as! UICollectionViewListCell
                cell.layer.cornerRadius = 12
                cell.layer.masksToBounds = true
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowRadius = 4
                return cell
            }
        })
        
            
    }
    
    private func makeCardLayout() -> UICollectionViewLayout {
    
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

}

class ProfileListCell: UICollectionViewListCell {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    

}
