//
//  UIView+Ext.swift
//  Pr2503
//
//  Created by Daniil (work) on 18.03.2024.
//

import UIKit

extension UIView {
    func configureTapGestureForEndEditing() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(gesture)
    }

    @objc
    private func viewTapped() {
        endEditing(true)
    }
}
