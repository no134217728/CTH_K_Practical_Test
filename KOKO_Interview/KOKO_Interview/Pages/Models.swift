//
//  Models.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import Foundation

struct Man: Codable {
    let name: String
    let kokoid: String
}

struct Friend: Codable {
    let name: String
    let status: InvitationStatus
    let isTop: Bool
    let fid: String
    let updateDate: String
    
    var dateTimeInterval: TimeInterval {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        
        let date = format.date(from: updateDate)
        return date?.timeIntervalSince1970 ?? 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(InvitationStatus.self, forKey: .status)
        self.isTop = {
            let original = try? container.decode(String.self, forKey: .isTop)
            return (original == "1")
        }()
        self.fid = try container.decode(String.self, forKey: .fid)
        self.updateDate = {
            let original = try? container.decode(String.self, forKey: .updateDate)
            return original?.replacingOccurrences(of: "/", with: "") ?? ""
        }()
    }
}

enum InvitationStatus: UInt8, Codable {
    case sent = 0
    case complete = 1
    case inviting = 2
}
