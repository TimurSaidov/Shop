//
//  Clothes+Extension.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

extension Clothes {
    
    
    // MARK: Public
    
    static func parse(json: [String: Any]) -> Clothes? {
        var clothes: Clothes?
        
        guard
            let name = json[GoodsDetail.name.rawValue] as? String,
            let description = json[GoodsDetail.description.rawValue] as? String,
            let cost = json[GoodsDetail.cost.rawValue] as? Int
            else { return nil }
        let count = json[GoodsDetail.count.rawValue] as? Int
        let price = json[GoodsDetail.price.rawValue] as? Int
        
        clothes = Clothes(name: name,
                         description: description,
                         cost: cost,
                         count: count, price: price)
        
        return clothes
    }
}
