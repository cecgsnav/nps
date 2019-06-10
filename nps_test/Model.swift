//
//  NPS-Entity.swift
//  nps
//
//  Created by Cecilia Soto on 6/4/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import Foundation

struct NPS: Decodable {
    let id: Int
    let nps: Int
    let daysSinceSignup: Int
    let activityViews: Int
    let userPlan: UserPlan
    let build: BuildInfo
    
    enum CodingKeys: String, CodingKey {
        case id, nps
        case daysSinceSignup = "days_since_signup"
        case activityViews = "activity_views"
        case userPlan = "user_plan"
        case build = "build"
    }
}

enum UserPlan: String, Decodable, CaseIterable, Equatable {
    case Freemium = "freemium", Premium = "premium"
}

struct BuildInfo: Decodable {
    let releaseDate: Date
    let versionNumber: String
    
    enum CodingKeys: String, CodingKey {
        case releaseDate = "release_date"
        case versionNumber = "version"
    }
}

struct DataArray<G: Decodable>: Decodable {
    let data: [G]
}
