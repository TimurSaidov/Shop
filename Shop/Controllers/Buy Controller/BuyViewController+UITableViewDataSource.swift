//
//  BuyViewController+UITableViewDataSource.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

extension BuyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BuyTableViewCell
        let clothes = order[indexPath.row]
        cell.nameLabel.text = clothes.name
        if let count = clothes.count {
            cell.countLabel.text = "\(count) шт."
        } else {
            cell.countLabel.text = "0 шт."
        }
        if let price = clothes.price {
            cell.priceLabel.text = "\(price) ₽"
        }
        if indexPath.row == order.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return cell
    }
}
