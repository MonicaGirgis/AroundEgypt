//
//  HomeViewController.swift
//  AroundEgypt
//
//  Created by Monica Girgis Kamel on 24/03/2023.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel: HomeViewModel = HomeViewModel()
    private var searchMood: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateView()
    }
    
    
    private func setupUI() {
        // MARK: - Cell registeration
        homeCollectionView.register(ExperienceCollectionViewCell.nib, forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        homeCollectionView.register(HorizontalCollectionCell.nib, forCellWithReuseIdentifier: HorizontalCollectionCell.identifier)
        homeCollectionView.register(DescriptionCollectionViewCell.nib, forCellWithReuseIdentifier: DescriptionCollectionViewCell.identifier)
        homeCollectionView.register(UINib(nibName: String(describing: HeaderCollectionReusableView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HeaderCollectionReusableView.self))
        
        // MARK: - Search Set up
        navigationItem.titleView = searchBar
    }
    
    private func updateView() {
        viewModel.autoUpdateView = { [weak self] in
            guard let self = self else { return }
            self.homeCollectionView.reloadData()
        }
        
        viewModel.failedWithError = { [weak self] errorMsg in
            guard let self = self else { return }
            self.showAlert(message: errorMsg)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchMood ? 1 : viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMood {
            return viewModel.searchData.count
        }
        
        switch viewModel.sections[section] {
        case .recent:
            return viewModel.recentData.count
            
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if searchMood {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExperienceCollectionViewCell.identifier, for: indexPath) as! ExperienceCollectionViewCell
            cell.configure(with: viewModel.searchData[indexPath.row])
            cell.didLike = { [weak self] in
                guard let self = self, self.viewModel.searchData[indexPath.row].isLiked == nil else { return }
                self.viewModel.likeExperience(with: self.viewModel.searchData[indexPath.row], isSearch: true)
            }
            return cell
        }
        
        switch viewModel.sections[indexPath.section] {
        case .welcome:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionViewCell.identifier, for: indexPath) as! DescriptionCollectionViewCell
            cell.setData(desc: "Now you can explore any experience in 360 degrees and get all the details about it all in one place.")
            return cell
            
        case .recommened:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionCell.identifier, for: indexPath) as! HorizontalCollectionCell
            cell.setData(dataCount: viewModel.recomendedData.count, view: ExperienceCollectionViewCell.self)
            
            cell.configureCell = { [weak self] customIndexPath in
                let customCell = cell.collectionView.dequeueReusableCell(withReuseIdentifier: ExperienceCollectionViewCell.identifier, for: customIndexPath) as! ExperienceCollectionViewCell
                guard let self = self else { return customCell}
                customCell.configure(with: self.viewModel.recomendedData[customIndexPath.row], hideStatusView: false)
                customCell.didLike = { [weak self] in
                    guard let self = self, self.viewModel.recomendedData[customIndexPath.row].isLiked == nil else { return }
                    self.viewModel.likeExperience(with: self.viewModel.recomendedData[customIndexPath.row], at: .recommened)
                }
                return customCell
            }
            
            cell.sizeForItem = { _ in
                return CGSize(width: collectionView.frame.width, height: 234)
            }
            
            cell.didSelectCellAt = { [weak self] customIndexPath in
                guard let self = self else { return }
                let displayView = UIHostingController(rootView: ExperienceDetails(experience: self.viewModel.recomendedData[customIndexPath.row]))
                self.navigationController?.pushViewController(displayView, animated: true)
            }
            
            return cell
            
        case .recent:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExperienceCollectionViewCell.identifier, for: indexPath) as! ExperienceCollectionViewCell
            cell.configure(with: viewModel.recentData[indexPath.row])
            cell.didLike = { [weak self] in
                guard let self = self, self.viewModel.recentData[indexPath.row].isLiked == nil else { return }
                self.viewModel.likeExperience(with: self.viewModel.recentData[indexPath.row], at: .recent)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if searchMood {
            return CGSize(width: collectionView.frame.width, height: 234)
        }
        
        switch viewModel.sections[indexPath.section] {
        case .welcome:
            return CGSize(width: collectionView.frame.width, height: 40)
        case .recent, .recommened:
            return CGSize(width: collectionView.frame.width, height: 234)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HeaderCollectionReusableView.self), for: indexPath) as! HeaderCollectionReusableView
        
        if searchMood {
            assert(false, "")
        }
        
        if let title = viewModel.sections[indexPath.section].title {
            sectionHeader.setData(title: title)
            return sectionHeader
        }else{
            assert(false, "")
        }
        
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if searchMood {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
        
        if viewModel.sections[section].title != nil{
            return CGSize(width: collectionView.frame.width, height: 56)
        }else{
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if searchMood {
            let displayView = UIHostingController(rootView: ExperienceDetails(experience: viewModel.searchData[indexPath.row]))
            navigationController?.pushViewController(displayView, animated: true)
        }
        
        switch viewModel.sections[indexPath.section] {
        case .recent :
            let displayView = UIHostingController(rootView: ExperienceDetails(experience: viewModel.recentData[indexPath.row]))
            navigationController?.pushViewController(displayView, animated: true)
        default:
            break
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            viewModel.resetSearch()
            searchMood = false
            return
        }
        searchMood = true
        viewModel.searchWith(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.resetSearch()
        searchMood = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let txt = searchBar.text, !txt.isEmpty else {
            viewModel.resetSearch()
            searchMood = false
            return
        }
        searchMood = true
        viewModel.searchWith(txt)
    }
}
