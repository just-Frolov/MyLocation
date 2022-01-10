//
//  Extensions.swift
//  MyLocation
//
//  Created by Данил Фролов on 04.01.2022.
//

import Foundation

extension String {
    mutating func addingDevidingPrefixIfNeeded() {
        guard !self.isEmpty else { return }
        self = self + ", "
    }
}
