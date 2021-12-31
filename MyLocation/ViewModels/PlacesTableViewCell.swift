//
//   
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import UIKit
import Kingfisher

class PlacesTableViewCell: UITableViewCell {
    //MARK: - Static Constant -
    static let indentifier = "PlacesTableViewCell"
    
    //MARK: - UI Elements -
    lazy var placeIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.textColor = .systemMint
        label.numberOfLines = 0
        return label
    }()
    
    lazy var placeAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var placeIsOpenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    lazy var placeRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private -
    private func addSubview() {
        contentView.addSubview(placeIcon)
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(placeAddressLabel)
        contentView.addSubview(placeIsOpenLabel)
        contentView.addSubview(placeRatingLabel)
    }
    
    private func setConstraints() {
        setPlaceIconConstraints()
        setPlaceNameLabelConstraints()
        setPlaceAddressLabelConstraints()
        setPlaceIsOpenLabelConstraints()
        setPlaceRatingLabelConstraints()
    }
    
    private func setPlaceIconConstraints() {
        let iconSize: CGFloat = 40
        
        placeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeIcon.widthAnchor.constraint(equalToConstant: iconSize),
            placeIcon.heightAnchor.constraint(equalToConstant: iconSize),
            placeIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            placeIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setPlaceNameLabelConstraints() {
        let spaceAtRight: CGFloat = -10
        let spaceAtLeft: CGFloat = 10
        let spaceAtTop: CGFloat = 10
        let spaceAtBottom: CGFloat = -49
        
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeNameLabel.leftAnchor.constraint(equalTo: placeIcon.rightAnchor, constant: spaceAtLeft),
            placeNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: spaceAtRight),
            placeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spaceAtTop),
            placeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: spaceAtBottom)
        ])
    }
    
    private func setPlaceAddressLabelConstraints() {
        let spaceAtRight: CGFloat = -10
        let spaceAtLeft: CGFloat = 10
        let spaceAtTop: CGFloat = 40
        let spaceAtBottom: CGFloat = -20
        
        placeAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeAddressLabel.leftAnchor.constraint(equalTo: placeIcon.rightAnchor, constant: spaceAtLeft),
            placeAddressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: spaceAtRight),
            placeAddressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spaceAtTop),
            placeAddressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: spaceAtBottom)
        ])
    }
    
    private func setPlaceIsOpenLabelConstraints() {
        let spaceAtRight: CGFloat = -50
        let spaceAtLeft: CGFloat = 10
        let spaceAtTop: CGFloat = 60
        let spaceAtBottom: CGFloat = 0
        
        placeIsOpenLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeIsOpenLabel.leftAnchor.constraint(equalTo: placeIcon.rightAnchor, constant: spaceAtLeft),
            placeIsOpenLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: spaceAtRight),
            placeIsOpenLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spaceAtTop),
            placeIsOpenLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: spaceAtBottom)
        ])
    }
    
    private func setPlaceRatingLabelConstraints() {
        let spaceAtRight: CGFloat = -10
        let spaceAtLeft: CGFloat = 100
        let spaceAtTop: CGFloat = 60
        let spaceAtBottom: CGFloat = 0
        
        placeRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeRatingLabel.leftAnchor.constraint(equalTo: placeIcon.rightAnchor, constant: spaceAtLeft),
            placeRatingLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: spaceAtRight),
            placeRatingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spaceAtTop),
            placeRatingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: spaceAtBottom)
        ])
    }
    
    //MARK: - Public -
    public func configure(with model: Places) {
        placeNameLabel.text = model.name
        placeAddressLabel.text = model.vicinity
        placeRatingLabel.text = String(model.rating)
        if model.opening_hours.open_now {
            placeIsOpenLabel.text = "Open"
        } else {
            placeIsOpenLabel.text = "Close"
        }
        
        let url = URL(string: model.icon)
        placeIcon.kf.setImage(with: url)
    }
}
