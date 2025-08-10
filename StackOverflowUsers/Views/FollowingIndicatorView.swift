import UIKit

/// A visual display that indicates if a user is being followed.
class FollowingIndicatorView: UIView {

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The following state for the view.
    var isFollowing: Bool = false {
        didSet {
            updateState(animated: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(iconLabel)
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        updateState(animated: false)
    }
    
    private func updateState(animated: Bool) {
        let update = {
            if self.isFollowing {
                self.backgroundColor = .systemGreen
                self.iconLabel.text = "✓"
                self.iconLabel.textColor = .white
            } else {
                self.backgroundColor = .systemBackground
                self.iconLabel.text = "+"
                self.iconLabel.textColor = .systemBlue
                self.layer.borderWidth = 1.5
                self.layer.borderColor = UIColor.systemBlue.cgColor
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: update)
        } else {
            update()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }
}
