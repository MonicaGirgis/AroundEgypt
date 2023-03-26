//
//  UIImage + Extensions.swift
//  customer
//
//  Created by Monica Girgis Kamel on 15/01/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    func getAsync(_ url: String){
        if let imageURL = URL(string: url) {
            self.kf.indicatorType = .activity
          self.kf.setImage(with: imageURL, placeholder: UIImage())
        }else{
            self.image = UIImage(named: "default")
        }
      }
}
