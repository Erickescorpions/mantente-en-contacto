//
//  UIViewController+Alerts.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 22/11/25.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String = "Alert",
                   message: String,
                   buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showConfirmAlert(title: String = "Confirm",
                          message: String,
                          confirmTitle: String = "OK",
                          cancelTitle: String = "Cancel",
                          onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: confirmTitle, style: .default) { _ in
            onConfirm()
        }
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
