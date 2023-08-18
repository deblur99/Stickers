//
//  ReplyStore.swift
//  Stickers
//
//  Created by 한현민 on 2023/08/18.
//

import Foundation
import FirebaseFirestore

class ReplyStore: ObservableObject {
    @Published var replies: [Reply] = []
    
    var stickerId: String = ""
    
    let dbRef = Firestore.firestore().collection("Stickers")
    
    var sampleReply: Reply {
        Reply(text: "Good Job!")
    }
    
    func fetchReplies() {
//        replies = [
//            sampleReply, sampleReply, sampleReply
//        ]
        dbRef.document(stickerId).collection("Replies").getDocuments { (snapshot, error) in
            self.replies.removeAll()
            
            if let snapshot {
                var tempReplies: [Reply] = []
                
                for document in snapshot.documents {
                    let id: String = document.documentID
                    
                    let docData = document.data()   // [String: Any]
                    let username: String = docData["username"] as? String ?? ""
                    let text: String = docData["text"] as? String ?? ""
                    let createdAt: Double = docData["createdAt"] as? Double ?? 0.0
                    
                    let reply = Reply(id: id, username: username, text: text, createdAt: createdAt)
                    
                    tempReplies.append(reply)
                }
                
                self.replies = tempReplies
            }
        }
    }
    
    func addReply(_ reply: Reply) {
        dbRef.document(stickerId).collection("Replies")
            .document(reply.id)
            .setData(["username": reply.username,
                      "text": reply.text,
                      "createdAt": reply.createdAt])
        
        fetchReplies()
    }
}
