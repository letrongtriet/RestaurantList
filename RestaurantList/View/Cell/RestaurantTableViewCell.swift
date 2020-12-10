//
//  RestaurantTableViewCell.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import UIKit
import Combine

class RestaurantTableViewCell: UITableViewCell {

    // MARK: - Observable
    var favoriteButtonCallback = PassthroughSubject<Bool, Never>()

    // MARK: - Dependencies
    var item: RestaurantItem?

    // MARK: - UI Properties
    private lazy var restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        return label
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.backgroundColor = .clear

        stackView.addArrangedSubview(restaurantNameLabel)
        stackView.addArrangedSubview(descriptionLabel)

        return stackView
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "NotFavorite"), for: .normal)
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(handleFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()

    // MARK: - Lifecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Public methods
    func configUI() {
        guard let item = item else { return }

        restaurantNameLabel.text = item.restaurant.name.first?.value
        descriptionLabel.text = item.restaurant.shortDescription.first?.value
        restaurantImageView.loadImage(item.restaurant.listimage)
        favoriteButton.setImage(item.isFavorite ? UIImage(named: "Favorite") : UIImage(named: "NotFavorite"), for: .normal)
    }

    // MARK: - Private methods
    private func setupView() {
        contentView.addSubview(restaurantImageView)
        contentView.addSubview(labelsStackView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(divider)

        setConstraints()
    }

    private func setConstraints() {
        restaurantImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.leading.top.equalToSuperview().offset(8)
        }

        labelsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(restaurantImageView.snp.centerY)
            make.leading.equalTo(restaurantImageView.snp.trailing).offset(12)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-12)
        }

        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(restaurantImageView.snp.centerY)
        }

        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(labelsStackView.snp.leading)
            make.trailing.equalToSuperview()
            make.top.equalTo(restaurantImageView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-2)
        }
    }

    @objc private func handleFavoriteButtonTapped() {
        guard let item = item else { return }
        var isFavorite = item.isFavorite
        isFavorite.toggle()
        favoriteButtonCallback.send(isFavorite)
    }

}
