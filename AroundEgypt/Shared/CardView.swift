//
//  CardView.swift
//  Tatx
//
//  Created by Monica Girgis Kamel on 30/01/2022.
//

import Foundation
import UIKit



class RoundedCornersView: UIView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.makeRoundedCornersWith(radius: 8.0)
    }
}
