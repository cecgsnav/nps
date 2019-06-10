//
//  NpsScoresByVersionViewModel.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/9/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import Moya
import ReactiveMoya
import ReactiveCocoa
import ReactiveSwift
import UIKit

typealias UserPlanViewModel = UserPlan
typealias NpsScoreViewModel = (score: Int, usersInPlan: String, color: UIColor)

final class NpsScoresByVersionViewModel {
    
    private let provider = MoyaProvider<KineduAPI>()
    
    var npsScores = Dictionary<String,[NPS]>()
    var versionList: MutableProperty<[String]> = MutableProperty([])
    var selectedVersion: String = "" {
        didSet {
            updateNpsStatsForVersion()
        }
    }
    var selectedVersionFreemiumScore: MutableProperty<NpsScoreViewModel> = MutableProperty((score: 0, usersInPlan: "", color: .black))
    var selectedVersionPremiumScore: MutableProperty<NpsScoreViewModel> = MutableProperty((score: 0, usersInPlan: "", color: .black))
    
    private func updateNpsStatsForVersion() {
        UserPlan.allCases.forEach { (userPlan) in
            let npsScore = calculateNpsScore(userPlan: userPlan, version: selectedVersion)
            
            switch userPlan {
            case .Freemium:
                self.selectedVersionFreemiumScore.value = npsScore
            case .Premium:
                self.selectedVersionPremiumScore.value = npsScore
            }
        }
    }
    
    private func calculateNpsScore(userPlan: UserPlanViewModel, version: String) -> NpsScoreViewModel {
        let npsList = getNps(for: version)
            .filter({ $0.userPlan == userPlan })
        
        if npsList.isEmpty {
            return (score: 0, usersInPlan: "0", color: .black)
        }
        
        let percentage = NpsCalculator(scores: npsList).calculateNpsScore()
        let usersInPlan = npsList.count
        let color: UIColor = percentage < 70 ? .badNpsColor : .goodNpsColor
        
        return (score: percentage, usersInPlan: usersInPlan.description, color: color)
    }
    
    private func getNps(for version: String) -> [NPS] {
        guard let nps = npsScores[version] else {
            print("version not found")
            return []
        }
        return nps
    }
    
    func requestNpsList(completion: @escaping (() -> Void)) {
        provider.reactive.request(.getNPS).start { event in
            switch event {
            case let .value(response):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                guard let resultList = try? response.map([NPS].self, using: decoder, failsOnEmptyData: true) else {
                    print("error")
                    return
                }
                
                let resultDict = Dictionary(grouping: resultList, by: { $0.build.versionNumber })
                
                self.npsScores = resultDict
                self.versionList.value = self.getVersionsList()
                if let firstVersion = self.versionList.value.first {
                    self.selectedVersion = firstVersion
                }
                
            case let .failed(error):
                print("call failed with error \(String(describing: error.errorDescription))")
            default:
                break
            }
            
            completion()
        }
    }
    
    private func getVersionsList() -> [String] {
        return Array(npsScores.keys).sorted()
    }
    
}
