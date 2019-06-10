//
//  NpsDetailViewModel.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/10/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

typealias FlavorDataViewModel = (percentage: Int, activities: Int)

struct NpsDetailsViewModel {
    
    let version: String
    let scoreOrderedNps: [Int: [NPS]]
    
    var selectedScore: MutableProperty<Int> = MutableProperty(0)
    
    init(nps: [NPS], version: String) {
        self.version = version
        self.scoreOrderedNps = Dictionary(grouping: nps, by: { $0.nps })
    }
    
    func getUserPlanScoreCount(for plan: UserPlanViewModel) -> String {
        let npsList = scoreOrderedNps[selectedScore.value] ?? []
        
        let count = npsList.filter({ $0.userPlan == plan }).count
        
        return count.description
    }
    
    func getFlavorData() -> FlavorDataViewModel {
        let npsList = scoreOrderedNps[selectedScore.value] ?? []
        
        let totalCount = npsList.count
        
        let activitiesMode = firstMode(array: npsList.map { $0.activityViews })
        
        let percentage = (activitiesMode.occurences * 100) / totalCount
        
        return (percentage: percentage, activities: activitiesMode.mode)
    }
    
    private func countOccurrences(array: [Int]) -> [Int: Int] {
        return array.reduce(into: [:]) { (occurences, element) in occurences[element, default: 0] += 1}
    }
    
    private func firstMode(array: [Int]) -> (mode: Int, occurences: Int) {
        // Keeps track of the fist mode's num occurences.
        // Every other element with the same number of occurences is also a mode.
        var firstModeNumOccurences: Int? = nil
        
        let modes = countOccurrences(array: array)
            .sorted { pairA, pairB in pairA.value > pairB.value } // sorting in descending order of num occurences
            .lazy
            .prefix(while:) { (element, numOccurences) in  // Take all elements with the same num occurences
                if firstModeNumOccurences == nil { firstModeNumOccurences = numOccurences }
                return numOccurences == firstModeNumOccurences
            }
            //.map { (element, _) in element } // keep only the elements, not their counts
        
        if let firstModeAndCount = Array(modes).first {
            return (mode: firstModeAndCount.key, occurences: firstModeAndCount.value)
        }
        
        return (mode: 0, occurences: 0)
    }
    
}
