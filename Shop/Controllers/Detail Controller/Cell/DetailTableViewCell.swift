//
//  DetailTableViewCell.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell, UITextFieldDelegate {

    
    // MARK: Outlets
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoTextField: UITextField!
    
    
    // MARK: Public Properties
    
    var key: GoodsDetail?
    weak var delegate: InfoTextFieldChangedDelegate?
    
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        if self.reuseIdentifier == "CellBuy" {
            infoTextField.delegate = self
            infoTextField.addTarget(self, action: #selector(infoTextFieldChanged), for: .editingChanged)
        }
        super.awakeFromNib()
    }
    
    
    // MARK: Private
    
    @objc private func infoTextFieldChanged() {
        if
            let text = infoTextField.text,
            let key = key
        {
            delegate?.textFieldChanged(text, key: key)
        }
    }
    
    
    // MARK: Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
