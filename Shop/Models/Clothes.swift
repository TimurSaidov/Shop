//
//  Clothes.swift
//  Shop
//
//  Created by Timur Saidov on 01/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

struct Clothes: Hashable {
    
    let name: String
    let description: String
    let cost: Int
    var count: Int?
    var price: Int?
}
