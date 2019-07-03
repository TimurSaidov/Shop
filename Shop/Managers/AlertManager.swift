//
//  AlertManager.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class AlertManager {
    
    
    // MARK: Public Properties
    
    static let shared = AlertManager()
    
    
    // MARK: Public
    
    func savedSuccessfullyAlert() -> UIAlertController {
        let ac = UIAlertController(title: "Товар успешно сохранен", message: "Чтобы посмотреть товар, перейдите в меню Магазин", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        return ac
    }
    
    func addClothesToOrderAlert() -> UIAlertController {
        let ac = UIAlertController(title: "Товар успешно добавлен в корзину", message: "Перейдите в раздел Покупки, чтобы оформить заказ", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        return ac
    }
    
    func deleteOrderAlert(handler: @escaping () -> ()) -> UIAlertController {
        let ac = UIAlertController(title: "Вы действительно хотите удалить товар из Вашего заказа?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Удалить", style: .destructive) { action in
            handler()
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        ac.addAction(delete)
        ac.addAction(cancel)
        return ac
    }
    
    func orderDoneAlert(with price: Int) -> UIAlertController {
        let ac = UIAlertController(title: "Заказ оформлен за \(price) ₽", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        return ac
    }
}
