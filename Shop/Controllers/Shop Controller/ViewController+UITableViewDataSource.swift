//
//  ViewController+UITableViewDataSource.swift
//  Shop
//
//  Created by Timur Saidov on 01/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredShop.count
        }
        return shop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewCell
        let clothes = isFiltering ? filteredShop[indexPath.row] : shop[indexPath.row]
        cell.nameLabel.text = clothes.name
        cell.priceLabel.text = "\(clothes.cost) ₽"
        if indexPath.row == shop.count - 1 || indexPath.row == filteredShop.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return cell
    }
}
