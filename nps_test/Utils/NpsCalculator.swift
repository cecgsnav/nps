//
//  NpsCalculator.swift
//  nps
//
//  Created by Cecilia Soto on 6/6/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import Foundation

struct NpsCalculator {
    
    let detractorsTotal: Int //0 – 6: Detractors
    
    let passivesTotal: Int //7 – 8: Passives
    
    let promotersTotal: Int //9-10: Promoters
    
    let responsesTotal: Int
    
    init(scores: [NPS]) {
        var detractorsCount: Int = 0
        var passivesCount: Int = 0
        var promotersCount: Int = 0
        
        scores.forEach { (nps) in
            switch nps.nps {
            case 0...6: detractorsCount+=1
            case 7...8: passivesCount+=1
            case 9...10: promotersCount+=1
            default: break
            }
        }
        
        self.detractorsTotal = detractorsCount
        self.passivesTotal = passivesCount
        self.promotersTotal = promotersCount
        self.responsesTotal = scores.count
    }
    
    func calculateNpsScore() -> Int {
        let detractorsPercentage = (detractorsTotal * 100) / responsesTotal
        //let passivesPercentage = (passivesTotal / responsesTotal) * 100
        let promotersPercentage = (promotersTotal * 100) / responsesTotal
        
        return promotersPercentage - detractorsPercentage
    }
    
}
