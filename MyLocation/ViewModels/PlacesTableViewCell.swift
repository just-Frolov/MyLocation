//
//   
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    //MARK: - UI Elements -
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    //MARK: - Static Constant -
    static let indentifier = "PlacesTableViewCell"
    
    //MARK: - Life Cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(placeNameLabel)
        setPlaceNameLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private -
    private func setPlaceNameLabelConstraints() {
        let sizePlaceNameLabel: CGFloat = 50
        
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeNameLabel.widthAnchor.constraint(equalToConstant: sizePlaceNameLabel),
            placeNameLabel.heightAnchor.constraint(equalToConstant: sizePlaceNameLabel),
            placeNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    //MARK: - Public -
    public func configure(with model: String) {
        self.placeNameLabel.text = model
    }
}
