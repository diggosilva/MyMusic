//
//  Extensions.swift
//  MyMusic
//
//  Created by Diggo Silva on 02/11/24.
//

import UIKit

extension UITextField {
    public func configTextField(textField: UITextField, placeholder: String, keyboardType: UIKeyboardType = .default) {
        textField.placeholder = placeholder
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach({ addSubview($0) })
    }
}
