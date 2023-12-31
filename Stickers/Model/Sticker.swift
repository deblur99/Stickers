//
//  Sticker.swift
//  Stickers
//
//  Created by 한현민 on 2023/08/18.
//

import Foundation
import SwiftUI

struct Sticker: Identifiable {
    var id: String = UUID().uuidString
    var username: String = "Ned"
    var memo: String
    var colorIndex: Int
    var createdAt: Double = Date().timeIntervalSince1970
    
    var color: Color {
        switch colorIndex {
        case 0:
            return .cyan
        case 1:
            return .purple
        case 2:
            return .blue
        case 3:
            return .yellow
        case 4:
            return .brown
        default:
            return .white
        }
    }
    
    var createdDate: String {
        let dateCreatedAt: Date = .init(timeIntervalSince1970: createdAt)
        
        let dateFormatter: DateFormatter = .init()
        dateFormatter.locale = .init(identifier: "ko_kr")
        dateFormatter.timeZone = .init(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    var textForSharing: String {
        return "\(memo)\n\(username)\n\(createdDate)"
    }
}
