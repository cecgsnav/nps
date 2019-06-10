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

final class NpsScoresByVersionViewModel {
    
    private let provider = MoyaProvider<KineduAPI>()
    
    var npsScores = Dictionary<String,[NPS]>()
    var versionList: MutableProperty<[String]> = MutableProperty([])
    var selectedVersion: String = ""
    
    func requestNpsList() {
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
        }
    }
    
    func getVersionsList() -> [String] {
        return Array(npsScores.keys).sorted()
    }
    
}
