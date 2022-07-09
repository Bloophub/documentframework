//
//  TXTUIViewController.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/5/22.
//

import Foundation
import UIKit

protocol TXTErrorProtocol {
    func present_error(_ error: Error)
    func present_error_text(_ text: String)
    func present_alert(_ alert: UIAlertController)
}

extension TXTErrorProtocol where Self: UIViewController {
    func present_alert(_ alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func present_error(_ error: Error){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: APPNAME, message: error.localizedDescription, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func present_error_text(_ text: String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: APPNAME, message: text, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

class TXTBaseUIViewController: UIViewController, TXTErrorProtocol {
    
}

class TXTBaseUITableViewController: UITableViewController, TXTErrorProtocol {
    
}
