//
//  HomeViewModel.swift
//  AroundEgypt
//
//  Created by Monica Girgis Kamel on 24/03/2023.
//

import Foundation

class HomeViewModel {
        
    init() {
        fetchData()
    }
    
    private (set) var sections: [HomeSections] = [.welcome]
    private (set) var recomendedData: [Experience] = []
    private (set) var recentData: [Experience] = []
    private (set) var searchData: [Experience] = []
    
    private var myGroup = DispatchGroup()
    
    var autoUpdateView: (()->())?
    var failedWithError: ((String)->())?
    
    private func fetchData() {
        
        if Network.reachability.isReachable {
            getRecommendedData()
            getRecentData()
        }else{
            getCoreDataItems()
            sections.append(.recommened)
            sections.append(.recent)
            autoUpdateView?()
        }
    
        myGroup.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return}
            
            if strongSelf.sections.count > 2 {
                strongSelf.sections[1] = .recommened
                strongSelf.sections[2] = .recent
            }
            strongSelf.saveToExperienceCD()
            strongSelf.autoUpdateView?()
        }
    }
    
     func getRecommendedData() {
        myGroup.enter()
        APIRoute.shared.fetchRequest(clientRequest: .getExperiences(isRecommended: true), decodingModel: Response<[Experience]>.self) { [weak self] result in
            guard let strongSelf = self else { return}
            strongSelf.myGroup.leave()
            switch result {
            case .success(let data):
                if !data.data.isEmpty {
                    strongSelf.sections.append(.recommened)
                    strongSelf.recomendedData = data.data
                }
            case .failure(let error):
                strongSelf.failedWithError?(error.localizedDescription)
            }
        }
    }
    
    private func getRecentData() {
        myGroup.enter()
        APIRoute.shared.fetchRequest(clientRequest: .getExperiences(), decodingModel:  Response<[Experience]>.self) { [weak self] result in
            guard let strongSelf = self else { return}
            strongSelf.myGroup.leave()
            switch result {
            case .success(let data):
                if !data.data.isEmpty {
                    strongSelf.sections.append(.recent)
                    strongSelf.recentData = data.data
                }
            case .failure(let error):
                strongSelf.failedWithError?(error.localizedDescription)
            }
        }
    }

    
    private func saveToExperienceCD() {
        CoreDataManager.shared.addItem(entityName: String(describing: ExperienceCD.self)) { objc in
            guard let objc = objc as? ExperienceCD else { return}
            
            let itemsCD = CoreDataManager.shared.getItems(entity: ExperienceCD.fetchRequest())
            
            var allData: [Experience] = []
            allData.append(contentsOf: recomendedData)
            allData.append(contentsOf: recentData)
            
            allData.forEach { experience in
                
                if let item = itemsCD?.first(where: { $0.id == experience.id }) {
                    item.title = experience.title
                    item.desc = experience.description
                    item.detailedDesc = experience.detailedDescription
                    item.coverPhoto = experience.coverPhoto
                    item.address = experience.address
                    item.viewNo = Int64(experience.viewsNo ?? 0)
                    item.likesNo = Int16(experience.likesNo ?? 0)
                    item.isRecommended  = Int16(experience.recommended ?? 0)
                    CoreDataManager.shared.updateItem()
                }else{
                    objc.id = experience.id
                    objc.title = experience.title
                    objc.desc = experience.description
                    objc.detailedDesc = experience.detailedDescription
                    objc.coverPhoto = experience.coverPhoto
                    objc.address = experience.address
                    objc.viewNo = Int64(experience.viewsNo ?? 0)
                    objc.likesNo = Int16(experience.likesNo ?? 0)
                    objc.isRecommended  = Int16(experience.recommended ?? 0)
                }
            }
        }
    }
    
    private func getCoreDataItems() {
        guard let items = CoreDataManager.shared.getItems(entity: ExperienceCD.fetchRequest()), !items.isEmpty else { return}
        recomendedData = items.filter({ $0.isRecommended == 1 }).map({ Experience(id: $0.id, title: $0.title, coverPhoto: $0.coverPhoto, description: $0.desc, viewsNo: Int($0.viewNo), likesNo: Int($0.likesNo), recommended: Int($0.isRecommended), isLiked: nil, detailedDescription: $0.detailedDesc, address: $0.address) })
        
        recentData = items.map({ Experience(id: $0.id, title: $0.title, coverPhoto: $0.coverPhoto, description: $0.desc, viewsNo: Int($0.viewNo), likesNo: Int($0.likesNo), recommended: Int($0.isRecommended), isLiked: nil, detailedDescription: $0.detailedDesc, address: $0.address) })
    }
    
    private func getSearchResults(searchText: String, completion: ((Result<Response<[Experience]>, APIError>)->())?) {
        APIRoute.shared.fetchRequest(clientRequest: .getExperiences(searchText: searchText), decodingModel: Response<[Experience]>.self) { result in
           completion?(result)
        }
    }
    
    
    func resetSearch() {
        searchData = []
        autoUpdateView?()
    }
    
    func searchWith(_ text: String) {
        getSearchResults(searchText: text) { [weak self] result in
            guard let strongSelf = self else { return}
            switch result {
            case .success(let data):
                if !data.data.isEmpty {
                    strongSelf.searchData = data.data
                    strongSelf.autoUpdateView?()
                }
            case .failure(let error):
                strongSelf.failedWithError?(error.localizedDescription)
            }
        }
    }
    
    func likeExperience(with model: Experience, at section: HomeSections? = nil, isSearch: Bool = false) {
        APIRoute.shared.fetchRequest(clientRequest: .likeExperience(id: model.id ?? ""), decodingModel: Response<Int>.self) { [weak self] result in
            guard let strongSelf = self else { return}
            switch result {
            case .success(let data):
                let temp = Experience(id: model.id, title: model.title, coverPhoto: model.coverPhoto, description: model.description, viewsNo: model.viewsNo, likesNo: data.data, recommended: model.recommended, isLiked: "", detailedDescription: model.detailedDescription, address: model.address)
                
                if isSearch {
                    if let index = strongSelf.searchData.firstIndex(where: { $0.id == model.id }) {
                        strongSelf.searchData.remove(at: index)
                        strongSelf.searchData.insert(temp, at: index)
                    }
                }else {
                    if section == .recommened, let index = strongSelf.recomendedData.firstIndex(where: { $0.id == model.id }) {
                        strongSelf.recomendedData.remove(at: index)
                        strongSelf.recomendedData.insert(temp, at: index)
                        
                    }else if section == .recent, let index = strongSelf.recentData.firstIndex(where: { $0.id == model.id }) {
                        strongSelf.recentData.remove(at: index)
                        strongSelf.recentData.insert(temp, at: index)
                    }
                }
                strongSelf.autoUpdateView?()
            case .failure(let error):
                strongSelf.failedWithError?(error.localizedDescription)
            }
        }
    }
}
