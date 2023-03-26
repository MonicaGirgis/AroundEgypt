//
//  UIViewController+Extensions.swift
//  FFLASHH
//
//  Created by Mina Malak on 22/05/2021.
//

import UIKit

extension UIViewController{
    
    enum Actiontype{
        case Back
        case Dismiss
        case OK
        case Cancel
    }
    
    func showAlert(title: String? = "",message : String? = nil , alertAction: Actiontype? = nil,handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if let message = message{
            let attributedString = NSAttributedString(string: message, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black
            ])
          alert.setValue(attributedString, forKey: "attributedMessage")
        }
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
                
                switch alertAction{
                case .Back:
                    self.navigationController?.popViewController(animated: true)
                case .Dismiss:
                    self.dismiss(animated: true, completion: nil)
                default:
                    handler?(action)
                }
            }
        }))
        UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.classForCoder() as! UIAppearanceContainer.Type]).effect = UIBlurEffect(style: .dark)
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = "",message : String? = nil , alertAction: [Actiontype],handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if let message = message{
            let attributedString = NSAttributedString(string: message, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black
            ])
            alert.setValue(attributedString, forKey: "attributedMessage")
        }
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        
        alertAction.forEach { action in
            switch action{
            case .Back:
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                }))
            case .Dismiss:
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }))
            case .OK:
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                        handler?(action)
                    }
                }))
            case .Cancel:
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                    }
                }))
            }
        }
        UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.classForCoder() as! UIAppearanceContainer.Type]).effect = UIBlurEffect(style: .dark)
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
}
