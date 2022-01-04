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
        table.register(PlacesTableViewCell.self,
                       forCellReuseIdentifier: PlacesTableViewCell.id())
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
    
    //MARK: - Private Constans -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    public var currentLocation: String?
    private var places: [Place]!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addSubViews()
        setupConstraints()
        showSpinner()
        fetchPlaces()
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
    
    private func fetchPlaces() {
        guard let currentLocation = currentLocation else {
            noPlacesLabel.isHidden = false
            return
        }
        let locationString = "&location=\(currentLocation)"
        PlacesManager.shared.getPlaces(for: locationString) { [weak self] result in
            guard let strongSelf = self else {return}
            
            switch result {
            case .failure(let error):
                print("Failed to get places: \(error)")
                strongSelf.noPlacesLabel.isHidden = false
            case .success(let placesArray):
                strongSelf.places = placesArray
                strongSelf.configureTableView(placesArray.isEmpty)
            }
            
            strongSelf.spinner.dismiss(animated: true)
        }
    }
    
    private func configureTableView(_ isEmpty: Bool) {
        self.noPlacesLabel.isHidden = !isEmpty
        self.tableView.isHidden = isEmpty
        self.tableView.reloadData()
        self.setupTableView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: PlacesTableViewCell.id(),
                                                 for: indexPath) as! PlacesTableViewCell
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
