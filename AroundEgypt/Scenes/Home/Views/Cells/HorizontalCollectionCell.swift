//
//  HorizontalCollectionCell.swift
//  Handesmade
//
//  Created by Monica Girgis Kamel on 14/02/2022.
//

import UIKit

class HorizontalCollectionCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayCount: Int?
    
    var configureCell: ((IndexPath)->(UICollectionViewCell))?
    var didSelectCellAt: ((IndexPath)->())?
    var sizeForItem: ((IndexPath)->CGSize)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(dataCount arr: Int, view cell: UICollectionViewCell.Type){
        arrayCount = arr
        collectionView.register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
        collectionView.reloadData()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HorizontalCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = configureCell?(indexPath) else { return UICollectionViewCell()}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCellAt?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let size = sizeForItem?(indexPath) else { return CGSize(width: 0, height: 0)}
        return size
    }
}
