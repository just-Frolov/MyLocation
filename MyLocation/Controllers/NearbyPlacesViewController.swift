//
//  NearbyPlacesViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import SnapKit
import JGProgressHUD

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
    
    //MARK: - Private Constans -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var currentLocation: String?
    private var places: [Place] = []
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addSubViews()
        setupConstraints()
        showSpinner()
        fetchPlaces()
        setupTableView()
    }
    
    
    //MARK: - Private -
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        title = "Restaurants in a \(PlacesManager.shared.radius) km"
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
        PlacesManager.shared.getPlaces(for: currentLocation) { [weak self] result in
            guard let strongSelf = self else {return}
            strongSelf.spinner.dismiss(animated: true)
            
            switch result {
            case .failure(let error):
                strongSelf.showErrorAlert(with: error)
            case .success(let placesArray):
                strongSelf.places = placesArray
            }
            strongSelf.configureTableView(strongSelf.places.isEmpty)
        }
    }
    
    private func configureTableView(_ isEmpty: Bool) {
        self.noPlacesLabel.isHidden = !isEmpty
        self.tableView.isHidden = isEmpty
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - Extension -
//MARK: - UITableViewDataSource -
extension NearbyPlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        let cell = PlacesTableViewCell.dequeueingReusableCell(in: tableView, for: indexPath)
        cell.configure(with: place)
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension NearbyPlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: - Alert -
extension NearbyPlacesViewController {
    private func showErrorAlert(with message: Error) {
        let alert = UIAlertController(title: "Error", message: "Failed to get places: \(message)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
