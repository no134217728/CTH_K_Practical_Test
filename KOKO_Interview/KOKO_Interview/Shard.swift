//
//  Shard.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/31.
//

import Foundation

class SharedConfig {
    static let shared = SharedConfig()
    
    var apiService: APIService {
        guard let stage = Bundle.main.infoDictionary?["IS_MOCK"] as? String else { return APIRequest() }
        
        return stage == "1" ? MockAPIRequest() : APIRequest()
    }
}
