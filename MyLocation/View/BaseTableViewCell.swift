//
//  BaseTableViewCell.swift
//  MyLocation
//
//  Created by Данил Фролов on 04.01.2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell, TableRegistable {

}

protocol TableRegistable: UITableViewCell {
    
}

extension TableRegistable {
    static func register(in tableView: UITableView) {
        tableView.register(Self.self,
                           forCellReuseIdentifier: String(describing: self))
    }
    
    static func cellRegister(in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> Self {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self.self),
                                                 for: indexPath) as! Self
        return cell
    }
}
