//
//   
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import Kingfisher
import SnapKit

class PlacesTableViewCell: UITableViewCell {
    //MARK: - Static Constant -
    static let indentifier = "PlacesTableViewCell"
    
    //MARK: - UI Elements -
    private lazy var placeIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemMint
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var placeAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ratingAndOpenInfoView: UIView = {
        let view = UIView()
        view.addSubview(placeIsOpenLabel)
        view.addSubview(placeRatingLabel)
        return view
    }()

    private lazy var placeIsOpenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var placeRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
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
    }
    
    private func setupConstraints() {
        setupPlaceIconConstraints()
        setupPlaceNameLabelConstraints()
        setupPlaceAddressLabelConstraints()
        setupRatingAndOpenInfoViewConstraints()
        setupPlaceIsOpenLabelConstraints()
        setupPlaceRatingLabelConstraints()
    }
    
    private func setupPlaceIconConstraints() {
        let iconSize: CGFloat = 40
        let spaceAtLeft: CGFloat = 10
        
        placeIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(iconSize)
            make.left.equalTo(spaceAtLeft)
            make.centerY.equalTo(contentView.snp_centerYWithinMargins)
        }
    }
    
    private func setupPlaceNameLabelConstraints() {
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
    
    private func setupPlaceAddressLabelConstraints() {
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
    
    private func setupRatingAndOpenInfoViewConstraints() {
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
    
    private func setupPlaceIsOpenLabelConstraints() {
        placeIsOpenLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ratingAndOpenInfoView)
            make.right.equalTo(ratingAndOpenInfoView.snp_centerXWithinMargins)
            make.height.equalTo(ratingAndOpenInfoView)
        }
    }
    
    private func setupPlaceRatingLabelConstraints() {
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
