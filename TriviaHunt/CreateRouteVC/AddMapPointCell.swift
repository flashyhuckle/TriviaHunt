import UIKit

final class AddMapPointCell: UITableViewCell {
    var mapPointButtonPressed: (() -> Void)?
    
    
    private lazy var addMapPointButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add map point", for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addMapPointButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(addMapPointButton)
        
        NSLayoutConstraint.activate([
            addMapPointButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addMapPointButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addMapPointButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addMapPointButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addMapPointButtonPressed() {
        mapPointButtonPressed?()
    }
}
