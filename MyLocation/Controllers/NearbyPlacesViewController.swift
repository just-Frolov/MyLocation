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
        table.register(PlacesTableViewCell.self,
                       forCellReuseIdentifier: PlacesTableViewCell.indentifier)
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
    private var places: [Places]!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        showSpinner()
        fetchPlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    //MARK: - Private -
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Restaurants in a 5 km"
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
        let sizeNavBar: CGFloat = 44
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.width.bottom.equalTo(view)
            make.top.equalTo(view).offset(sizeNavBar)
        }
    }
    
    private func setupNoPlacesLabelConstraints() {
        let heightNoPlacesLabel: CGFloat = 20
        
        noPlacesLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(heightNoPlacesLabel)
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
                if placesArray.count == 0 {
                    strongSelf.noPlacesLabel.isHidden = false
                } else {
                    strongSelf.setupTableView()
                    strongSelf.tableView.isHidden = false
                    strongSelf.tableView.reloadData()
                }
            }
            
            strongSelf.spinner.dismiss(animated: true)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: PlacesTableViewCell.indentifier,
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


