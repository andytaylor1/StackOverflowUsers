import UIKit

/// View Controller for displaying the list of user profiles.
class ProfileListViewController: UICollectionViewController {
    
    /// Sections that can be displayed in the view.
    enum Section {
        case main
        case loading
        case error
    }
    
    /// Items that can be displayed in a section.
    enum Item: Hashable {
        case loading(UUID)
        case card(UserViewModel)
        case error(UUID)
    }
    
    /// The current state the view is displaying.
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
                collectionView.refreshControl?.endRefreshing()
                
            case .error(_):
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                snapshot.deleteAllItems()
                snapshot.appendSections([.error])
                snapshot.appendItems([.error(UUID())])
                dataSource?.apply(snapshot, animatingDifferences: true)
                collectionView.refreshControl?.endRefreshing()
                
            case nil:
                break
            }
        }
    }
    
    /// The associated coordinator for this view.
    var coordinator: ProfileCoordinator?
    
    /// The diffable data source used for handling content in the collection view.
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initDataSource()
    }
    
    private func setupUI() {
        // Setup collection view
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.collectionViewLayout = makeCardLayout()
        
        // Setup refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // Set navigation title
        navigationItem.title = "Stack Overflow Users"
    }
    
    @objc private func handleRefresh() {
        coordinator?.start()
    }
    
    private func initDataSource() {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            switch model {
            case .card(let model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Profile", for: indexPath) as! ProfileListCell
                
                // Configure cell appearance with animation
                UIView.animate(withDuration: 0.2) {
                    cell.backgroundColor = .systemBackground
                    cell.layer.cornerRadius = 12
                    cell.layer.masksToBounds = true
                    
                    // Add shadow
                    cell.layer.shadowColor = UIColor.black.cgColor
                    cell.layer.shadowOffset = CGSize(width: 0, height: 2)
                    cell.layer.shadowOpacity = 0.1
                    cell.layer.shadowRadius = 4
                    
                    // Configure content
                    cell.profileLabel.text = model.name
                    cell.reputationLabel.text = "Reputation: \(model.reputation)"
                    cell.imageView.image = model.profileImage
                    
                    // Update following indicator
                    cell.followingIndicator.isFollowing = model.isFollowing
                }
                
                return cell
                
            case .loading(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Loading", for: indexPath)
                cell.backgroundColor = .systemBackground
                cell.layer.cornerRadius = 12
                return cell
                
            case .error(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Error", for: indexPath)
                cell.backgroundColor = .systemBackground
                cell.layer.cornerRadius = 12
                
                // Add tap gesture for retry
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleRefresh))
                cell.addGestureRecognizer(tap)
                
                return cell
            }
        })
    }
    
    private func makeCardLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .estimated(90))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                    leading: 16,
                                                    bottom: 0,
                                                    trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(200))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                   subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                       leading: 0,
                                                       bottom: 16,
                                                       trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let snapshot = dataSource?.snapshot() else { return }
        
        let items = snapshot.itemIdentifiers(inSection: .main)
        guard indexPath.item < items.count else { return }
        
        let item = items[indexPath.item]
        if case .card(var model) = item {
            if let cell = collectionView.cellForItem(at: indexPath) as? ProfileListCell {
                model.toggleFollowing()
                // The indicator view will handle its own animation
                cell.followingIndicator.isFollowing = model.isFollowing
                // Update the snapshot with the modified model
                var newSnapshot = snapshot
                newSnapshot.reconfigureItems([.card(model)])
                self.dataSource?.apply(newSnapshot, animatingDifferences: true)
            }
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
