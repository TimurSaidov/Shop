//
//  BuyViewController+UITableViewDelegate.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

extension BuyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == order.count {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row == order.count {
            return nil
        } else {
            let delete = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Удалить") { [weak self] (action: UITableViewRowAction, indexPath) -> Void in
                guard let self = self else { return }
                let alertController = AlertManager.shared.deleteOrderAlert { [weak self] in
                    guard
                        let self = self,
                        let clothesPrice = self.order[indexPath.row].price,
                        let clothesCount = self.order[indexPath.row].count
                        else { return }
                    self.price -= clothesPrice
                    self.orderCount -= clothesCount
                    self.order.remove(at: indexPath.row)
                    self.orders.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                    self.buyButton.setTitle("Купить за \(self.price) ₽", for: .normal)
                    if self.orderCount == 0 {
                        self.navigationController?.tabBarItem.badgeValue = nil
                        self.plugView.isHidden = false
                    } else {
                        self.navigationController?.tabBarItem.badgeValue = "\(self.orderCount)"
                    }
                    UserDefaults.standard.set(self.orders, forKey: "Orders")
                    UserDefaults.standard.set(self.orderCount, forKey: "OrderCount")
                    UserDefaults.standard.synchronize()
                }
                self.present(alertController, animated: true, completion: nil)
            }
            delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            return [delete]
        }
    }
}
