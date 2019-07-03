//
//  PlistManager.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation

class PlistManager {
    
    
    // MARK: Public Properties
    
    static let shared = PlistManager()
    
    
    // MARK: Private Properties
    
    private let shopJSON: [[String: Any]] = [
        ["name": "Кеды",
         "description": "Кеды выполнены из натуральной кожи. Низкопрофильный дизайн не сковывает движений голеностопа, обеспечивая оптимальный контроль доски. Детали: цельнокроеный носок, плоская шнуровка; внутренняя текстильная отделка; гибкая резиновая подошва.",
         "cost": 4999],
        ["name": "Костюм спортивный",
         "description": "Спортивный костюм состоит из брюк и толстовки. Классическая модель выполнена из трикотажа с петельной изнанкой. Детали: толстовка с длинными рукавами, несъемный капюшон с кулиской по краю, застежка на молнию, 2 боковых кармана; брюки: эластичный пояс с резинкой и фиксирующим шнурком в кулиске, 2 боковых кармана, широкие манжеты.",
         "cost": 1999],
        ["name": "Толстовка",
         "description": "Толстовка выполнена из мягкого хлопкового трикотажа, махровая внутренняя отделка. Детали: прямой крой, модель без застежки, боковые карманы.",
         "cost": 499],
        ["name": "Поло",
         "description": "Состав: Хлопок - 100%. Сезон: мульти. Цвет: серый. Узор: однотонный.",
         "cost": 1399],
        ["name": "Шорты спортивные",
         "description": "Шорты от спортивного бренда выполнены из трикотажа. Модель прямого кроя. Детали: эластичный пояс, два боковых кармана.",
         "cost": 299],
        ["name": "Куртка демисезонная мужская ALPHA SLIM FIT N-3B",
         "description": "Куртка от бренда Аляска выполнена из теплого материала. Страна произодитель: США.",
         "cost": 8050]
    ]
    
    
    // MARK: Public
    
    func fetchClothes(completion: @escaping (_: [Clothes]) -> ()) {
        var shop: [Clothes] = []
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/Shop.plist"
        let urlPath = URL(fileURLWithPath: path)
        print(path)
        do {
            if try urlPath.checkResourceIsReachable() {
                print("File exists")
                if
                    let shopJSON = NSArray(contentsOfFile: path) as? [[String: Any]]
                {
                    for json in shopJSON {
                        guard let clothes = Clothes.parse(json: json) else { return }
                        shop.append(clothes)
                    }
                    
                    DispatchQueue.main.async {
                        completion(shop)
                    }
                } else {
                    
                }
            }
        } catch {
            print("File does't exist: \(error.localizedDescription)")
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            let clothesJSON = self.shopJSON as NSArray
            clothesJSON.write(toFile: path, atomically: true)
            
            for json in self.shopJSON {
                guard let clothes = Clothes.parse(json: json) else { return }
                shop.append(clothes)
            }
            
            DispatchQueue.main.async {
                completion(shop)
            }
        }
    }
    
    func saveClothesToFile(clothes: [Clothes], completion: @escaping () -> ()) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/Shop.plist"
        print(path)
        
        var clothesJSON: [[String: Any]] = []
        for item in clothes {
            var itemJSON: [String: Any] = [:]
            itemJSON[GoodsDetail.name.rawValue] = item.name
            itemJSON[GoodsDetail.description.rawValue] = item.description
            itemJSON[GoodsDetail.cost.rawValue] = item.cost
            clothesJSON.append(itemJSON)
        }
        
        let shopJSON = clothesJSON as NSArray
        shopJSON.write(toFile: path, atomically: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            completion()
        })
    }
}
