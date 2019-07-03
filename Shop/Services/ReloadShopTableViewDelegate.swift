//
//  reloadShopTableViewDelegate.swift
//  Shop
//
//  Created by Timur Saidov on 01/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

protocol ReloadShopTableViewDelegate: class {
    func reloadTableView(with clothes: Clothes)
}
