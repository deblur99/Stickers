//
//  StickerStore.swift
//  Stickers
//
//  Created by 한현민 on 2023/08/18.
//

import FirebaseFirestore
import Foundation

class StickerStore: ObservableObject {
    @Published var stickers: [Sticker] = []

    let dbRef = Firestore.firestore().collection("Stickers")
    
    func fetchStickers() {
//        stickers = [
//            Sticker(memo: "Hello World!", colorIndex: 0, createdAt: Date().timeIntervalSince1970),
//            Sticker(memo: "안녕하세요", colorIndex: 2, createdAt: Date().timeIntervalSince1970),
//        ]
        
        dbRef.getDocuments { (snapshot, _) in
            self.stickers.removeAll()
            
            if let snapshot {
                var tempStickers: [Sticker] = []
                
                for document in snapshot.documents {
                    let id: String = document.documentID
                    
                    let docData: [String: Any] = document.data()
                    let username: String = docData["username"] as? String ?? ""
                    let memo: String = docData["memo"] as? String ?? ""
                    let colorIndex: Int = docData["colorIndex"] as? Int ?? 0
                    let createdAt: Double = docData["createdAt"] as? Double ?? 0.0
                    
                    let sticker = Sticker(id: id, username: username, memo: memo, colorIndex: colorIndex, createdAt: createdAt)
                    
                    tempStickers.append(sticker)
                }
                
                self.stickers = tempStickers
            }
        }
    }
    
    func addSticker(_ sticker: Sticker) {
        dbRef.document(sticker.id)
            .setData(["username": sticker.username,
                      "memo": sticker.memo,
                      "colorIndex": sticker.colorIndex,
                      "createdAt": sticker.createdAt])
        
        fetchStickers()
    }
    
    func removeSticker(_ sticker: Sticker) {
//        guard let index = stickers.firstIndex(where: { $0 == sticker }) else {
//            return
//        }
        
//        stickers.remove(at: index)
        
        let id = sticker.id
        dbRef.document(id).delete()
        
        fetchStickers()
    }
    
    // 프리뷰를 위한 코드
    var sampleSticker: Sticker {
        Sticker(memo: "Hello World", colorIndex: 0, createdAt: Date().timeIntervalSince1970)
    }
}
