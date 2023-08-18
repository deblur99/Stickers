//
//  StickerDetailView.swift
//  Stickers
//
//  Created by 한현민 on 2023/08/18.
//

import SwiftUI

struct StickerDetailView: View {
    @StateObject var replyStore: ReplyStore = .init()
    
    var sticker: Sticker
    
    @State private var replyText: String = ""
    private var trimReplyText: String {
        replyText.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        VStack {
            StickerCellView(sticker: sticker)
            
            List(replyStore.replies) { reply in
                VStack(alignment: .leading, spacing: 14) {
                    Text(reply.text)
                    HStack {
                        Text(reply.username)
                        Spacer()
                        Text(reply.createdDate)
                    }
                    .font(.footnote)
                }
            }
            .listStyle(.plain)
            .refreshable {
                replyStore.fetchReplies()
            }
            
            HStack {
                TextField("Add Reply", text: $replyText)
                
                Button("Add") {
                    let reply = Reply(text: trimReplyText)
                    replyStore.addReply(reply)
                    replyText = ""
                }
                .disabled(trimReplyText.isEmpty)
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Sticker Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            replyStore.stickerId = sticker.id
            replyStore.fetchReplies()
        }
    }
}

struct StickerDetailView_Previews: PreviewProvider {
    @State static var sticker = StickerStore().sampleSticker
    
    static var previews: some View {
        NavigationStack {
            StickerDetailView(sticker: sticker)
        }
    }
}
