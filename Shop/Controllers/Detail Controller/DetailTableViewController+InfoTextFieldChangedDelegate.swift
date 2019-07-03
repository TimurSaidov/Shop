//
//  DetailTableViewController+InfoTextFieldChangedDelegate.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

extension DetailTableViewController: InfoTextFieldChangedDelegate {
    
    func textFieldChanged(_ text: String, key: GoodsDetail) {
        switch key {
        case .name:
            clothesName = text
            saveButtonEnable()
        case .description:
            clothesDescription = text
            saveButtonEnable()
        case .cost:
            guard
                text != .empty,
                let cost = Int(text)
                else {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
            }
            clothesCost = cost
            saveButtonEnable()
        case .count:
            break
        case .price:
            break
        }
    }
    
    
    // MARK: Private
    
    private func saveButtonEnable() {
        if
            clothesName != nil,
            clothesName != .empty,
            clothesName != .space,
            clothesDescription != nil,
            clothesDescription != .empty,
            clothesDescription != .space,
            clothesCost != nil
        {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
