//
//  NearbyPlacesViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import UIKit
import JGProgressHUD

class NearbyPlacesViewController: UIViewController {
    
    //MARK: - UI Elements -
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(PlacesTableViewCell.self,
                       forCellReuseIdentifier: PlacesTableViewCell.indentifier)
        return table
    }()
    
    private let noPlacesLabel: UILabel = {
        let label = UILabel()
        label.text = "No Places!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    //MARK: - Private Constans -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Private Variables -
    private var places: [Places]!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        showSpinner()
        fetchPlaces()
    }
    
    //MARK: - Private -
    private func setupSubView() {
        view.addSubview(tableView)
        view.addSubview(noPlacesLabel)
    }
    
    private func showSpinner() {
        spinner.show(in: view)
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //TODO:
    private func fetchPlaces() {
        PlacesManager.shared.getPlaces(for: "&location=-33.8670522%2C151.1957362") { [weak self] result in
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
                }
            }
            
            strongSelf.spinner.dismiss(animated: true)
        }
    }
}

//MARK: - Extension -
extension NearbyPlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeName = places[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: PlacesTableViewCell.indentifier,
                                                 for: indexPath) as! PlacesTableViewCell
        cell.configure(with: placeName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


