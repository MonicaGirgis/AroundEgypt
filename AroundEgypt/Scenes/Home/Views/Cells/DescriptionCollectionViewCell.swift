//
//  DescriptionCollectionViewCell.swift
//  AroundEgypt
//
//  Created by Monica Girgis Kamel on 24/03/2023.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(desc: String) {
        descLabel.text = desc
    }

}
