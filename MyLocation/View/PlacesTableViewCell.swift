//
//   
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import UIKit
import Kingfisher
import SnapKit

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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
    
    lazy var ratingAndOpenInfoView = UIView()
    
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
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private -
    private func addSubviews() {
        contentView.addSubview(placeIcon)
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(placeAddressLabel)
        contentView.addSubview(ratingAndOpenInfoView)
        ratingAndOpenInfoView.addSubview(placeIsOpenLabel)
        ratingAndOpenInfoView.addSubview(placeRatingLabel)
    }
    
    private func setConstraints() {
        setPlaceIconConstraints()
        setPlaceNameLabelConstraints()
        setPlaceAddressLabelConstraints()
        setRatingAndOpenInfoViewConstraints()
        setPlaceIsOpenLabelConstraints()
        setPlaceRatingLabelConstraints()
    }
    
    private func setPlaceIconConstraints() {
        let iconSize: CGFloat = 40
        let spaceAtLeft: CGFloat = 10
        
        placeIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(iconSize)
            make.left.equalTo(spaceAtLeft)
            make.centerY.equalTo(contentView.snp_centerYWithinMargins)
        }
    }
    
    private func setPlaceNameLabelConstraints() {
        let spaceAtRight: CGFloat = 5
        let spaceAtLeft: CGFloat = 60
        let spaceAtTop: CGFloat = 10
        let spaceAtBottom: CGFloat = 50
        
        placeNameLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: spaceAtTop,
                                                               left: spaceAtLeft,
                                                               bottom: spaceAtBottom,
                                                               right: spaceAtRight))
        }
    }
    
    private func setPlaceAddressLabelConstraints() {
        let spaceAtRight: CGFloat = 5
        let spaceAtLeft: CGFloat = 60
        let spaceAtTop: CGFloat = 40
        let spaceAtBottom: CGFloat = 20
        
        placeAddressLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: spaceAtTop,
                                                               left: spaceAtLeft,
                                                               bottom: spaceAtBottom,
                                                               right: spaceAtRight))
        }
    }
    
    private func setRatingAndOpenInfoViewConstraints() {
        let spaceAtRight: CGFloat = 5
        let spaceAtLeft: CGFloat = 60
        let spaceAtTop: CGFloat = 60
        let spaceAtBottom: CGFloat = 0
        
        ratingAndOpenInfoView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: spaceAtTop,
                                                               left: spaceAtLeft,
                                                               bottom: spaceAtBottom,
                                                               right: spaceAtRight))
        }
    }
    
    private func setPlaceIsOpenLabelConstraints() {
        placeIsOpenLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ratingAndOpenInfoView)
            make.right.equalTo(ratingAndOpenInfoView.snp_centerXWithinMargins)
            make.height.equalTo(ratingAndOpenInfoView)
        }
    }
    
    private func setPlaceRatingLabelConstraints() {
        placeRatingLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ratingAndOpenInfoView.snp_centerXWithinMargins)
            make.right.equalTo(ratingAndOpenInfoView)
            make.height.equalTo(ratingAndOpenInfoView)
        }
    }
    
    //MARK: - Public -
    public func configure(with model: Places) {
        placeNameLabel.text = model.name
        placeAddressLabel.text = model.vicinity
        placeRatingLabel.text = String(model.rating ?? 0)
        
        let url = URL(string: model.icon)
        placeIcon.kf.setImage(with: url)
        
        guard let isOpen = model.opening_hours else {
            placeIsOpenLabel.text = "No Information"
            return
        }
        
        placeIsOpenLabel.text = isOpen.open_now ?  "Open" : "Close"
    }
}
