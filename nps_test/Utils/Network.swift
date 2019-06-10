//
//  Network.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/9/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import Moya

enum KineduAPI {
    case getNPS
}

extension KineduAPI: TargetType {
    var baseURL: URL { return URL(string: "http://demo.kinedu.com/")! }
    
    var path: String {
        switch self {
        case .getNPS:
            return "bi/nps"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}
