//
//  ExperienceCollectionViewCell.swift
//  AroundEgypt
//
//  Created by Monica Girgis Kamel on 24/03/2023.
//

import UIKit

class ExperienceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var likesView: UIView!
    
    var didLike: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        coverImageView.makeRoundedCornersWith(radius: 8.0)
        
        let tapGestur = UITapGestureRecognizer(target: self, action: #selector(likeSelected))
        likesView.addGestureRecognizer(tapGestur)
    }
    
    @objc
    private func likeSelected() {
        didLike?()
    }
    
    func configure(with model: Experience, hideStatusView: Bool = true) {
        heartImageView.image = model.isLiked != nil ? UIImage(systemName: "heart.fill") :  UIImage(systemName: "heart")
        coverImageView.getAsync(model.coverPhoto ?? "")
        viewsLabel.text = "\(model.viewsNo ?? 0)"
        likesLabel.text = "\(model.likesNo ?? 0)"
        titleLabel.text = model.title ?? ""
        statusView.isHidden = hideStatusView
    }
}
