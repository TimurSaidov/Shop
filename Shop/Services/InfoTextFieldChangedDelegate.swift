//
//  InfoTextFieldChangedDelegate.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

protocol InfoTextFieldChangedDelegate: class {
    func textFieldChanged(_ text: String, key: GoodsDetail)
}
