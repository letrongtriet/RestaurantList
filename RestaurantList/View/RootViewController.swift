//
//  ViewController.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import UIKit
import Combine
import SnapKit

class RootViewController: UIViewController {

    // MARK: - Init
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties
    private let viewModel: RootViewModel
    private var bag = Set<AnyCancellable>()
    private var restaurants = [RestaurantItem]()
    private var currentErrorMessage = ""

    // MARK: - UI Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "RestaurantTableViewCell")

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .white
        loadingIndicator.tintColor = .white
        loadingIndicator.startAnimating()

        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        return view
    }()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        binding()
    }

    // MARK: - Private methods
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
        setConstraints()
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func binding() {
        viewModel
            .$state
            .sink(receiveValue: { [weak self] state in
                self?.handleNewState(state)
            })
            .store(in: &bag)
    }

    private func handleNewState(_ state: State) {
        if case State.fetching = state {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }

        switch state {
        case let .fetched(items):
            restaurants = items
            tableView.reloadDataAnimated()
        case let .empty(message):
            restaurants = []
            currentErrorMessage = message
            tableView.reloadDataAnimated()
        case let .error(errorMessage):
            restaurants = []
            currentErrorMessage = errorMessage
            tableView.reloadDataAnimated()
        default:
            return
        }
    }

    private func handleFavoriteButtonCallback(_ isFavorite: Bool, item: RestaurantItem) {
        if isFavorite {
            viewModel.add(id: item.restaurant.id.oid)
        } else {
            viewModel.remove(id: item.restaurant.id.oid)
        }
    }

}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if restaurants.count == 0 {
            self.tableView.setEmptyMessage(currentErrorMessage)
        } else {
            self.tableView.restore()
        }
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        let item = restaurants[indexPath.row]

        cell.item = item
        cell.favoriteButtonCallback
            .sink(receiveValue: { [weak self] isFavorite in
                self?.handleFavoriteButtonCallback(isFavorite, item: item)
            })
            .store(in: &bag)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RestaurantTableViewCell else { return }
        cell.configUI()
    }
}

