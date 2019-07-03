//
//  ViewController+ReloadShopTableViewDelegate.swift
//  Shop
//
//  Created by Timur Saidov on 01/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

extension ViewController: ReloadShopTableViewDelegate {
    
    func reloadTableView(with clothes: Clothes) {
        shop.append(clothes)
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            PlistManager.shared.saveClothesToFile(clothes: self.shop) { [weak self] in
                guard let self = self else { return }
                let alertController = AlertManager.shared.savedSuccessfullyAlert()
                self.present(alertController, animated: true, completion: nil)
                let newIndexPath = IndexPath(row: self.shop.count - 1, section: 0)
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
