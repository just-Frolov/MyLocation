//
//  BaseTableViewCell.swift
//  MyLocation
//
//  Created by Данил Фролов on 04.01.2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell, TableRegistable, CellDeletable {

}

protocol TableRegistable: UITableViewCell {
    
}

extension TableRegistable {
    static func register(in tableView: UITableView) {
        tableView.register(Self.self,
                           forCellReuseIdentifier: String(describing: self))
    }
    
    static func xibRegister(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil), forCellReuseIdentifier: String(describing: self))
    }
}

protocol CellDeletable: UITableViewCell {
   
}

extension CellDeletable {
    static func dequeueingReusableCell(in tableView: UITableView, for indexPath: IndexPath) -> Self {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self),
                                                 for: indexPath) as! Self
        return cell
    }
}


