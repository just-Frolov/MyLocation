//
//  NearbyPlacesViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import SnapKit
import JGProgressHUD
import UIKit

class NearbyPlacesViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        PlacesTableViewCell.register(in: table)
        return table
    }()
    
    private lazy var noPlacesLabel: UILabel = {
        let label = UILabel()
        label.text = "No Places!"
        label.textAlignment = .center
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    //MARK: - Constans -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var presenter: NearbyPlacesPresenter!
    private var places: [Place] = []
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addSubViews()
        setupConstraints()
        showSpinner()
        presenter.getNearbyPlaces()
        setupTableView()
    }
    
    //MARK: - Private -
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        let radius = PlacesManager.shared.radius
        title = "Restaurants in a \(radius) km"
        backButton.title = "Map"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        setupNavigationBarAppearence()
    }
    
    private func setupNavigationBarAppearence() {
        let navAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
        navigationController?.navigationBar.standardAppearance = navAppearance
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(noPlacesLabel)
    }
    
    private func setupConstraints() {
        setupTableViewConstraints()
        setupNoPlacesLabelConstraints()
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.width.bottom.equalTo(view)
            make.top.equalTo(view).offset(44)
        }
    }
    
    private func setupNoPlacesLabelConstraints() {
        noPlacesLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(20)
            make.center.equalTo(view)
        }
    }
    
    private func showSpinner() {
        spinner.show(in: view)
    }
    
    private func hideSpinner() {
        spinner.dismiss(animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - Extension -
extension NearbyPlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        let cell = PlacesTableViewCell.cellRegister(in: tableView, for: indexPath)
        cell.configure(with: place)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension NearbyPlacesViewController: NearbyPlacesViewProtocol {
    func success(with places: [Place]) {
        self.places = places
        configureTableView(isEmpty: false)
    }
    
    func failure(with error: Error) {
        configureTableView(isEmpty: true)
    }
    
    private func configureTableView(isEmpty: Bool) {
        self.hideSpinner()
        self.noPlacesLabel.isHidden = !isEmpty
        self.tableView.isHidden = isEmpty
        self.tableView.reloadData()
    }
}
