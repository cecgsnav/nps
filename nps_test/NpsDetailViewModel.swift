//
//  NpsDetailViewModel.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/10/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import Foundation

struct NpsDetailsViewModel {
    
    let version: String
    let scoreOrderedNps: [Int: [NPS]]
    
    var selectedScore: Int = 0
    
    init(nps: [NPS], version: String) {
        self.version = version
        self.scoreOrderedNps = Dictionary(grouping: nps, by: { $0.nps })
    }
    
    func getUserPlanScoreCount(for plan: UserPlanViewModel) -> String {
        let npsList = scoreOrderedNps[selectedScore] ?? []
        
        let count = npsList.filter({ $0.userPlan == plan }).count
        
        return count.description
    }
    
}
