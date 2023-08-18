//
//  AddingStickerView.swift
//  Stickers
//
//  Created by 한현민 on 2023/08/18.
//

import SwiftUI

struct AddingStickerView: View {
    @ObservedObject var stickerStore: StickerStore
    @Binding var isShowingAddView: Bool
    
    @State private var memo: String = ""
    @State private var colorIndex: Int = 0
    
    let colors: [Color] = [
        .cyan, .purple, .blue, .yellow, .brown
    ]
    
    var trimMemo: String {
        // 파이썬의 str.strip('\n')과 동일
        // 양끝의 공백문자를 제거한 문자열을 반환한다.
        memo.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            // ScrollView를 쓰면 영역이 위아래로 확대된다.
            // Form만 있다면 가운데로 좁아진다.
            ScrollView {
                Form {
                    Section("Color") {
                        HStack {
                            // enumerated() 사용하여 index, 요소 두 가지를 후행 클로저에서 사용할 수 있도록 한다. enumerated()로 반환된 값을 ForEach문에서 사용하려면 Array로 형변환을 해 주어야 한다.
                            // 이렇게 형변환된 Array는 Identifiable을 준수하지 않으므로 id값을 offset 기준으로 따로 써준다.
                            ForEach(Array(colors.enumerated()), id: \.offset) { (index, color) in
                                
                                Button {
                                    colorIndex = index
                                } label: {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(color)
                                            .shadow(radius: 3)
                                            .frame(height: 60)
                                        
                                        if index == colorIndex {
                                            Image(systemName: "checkmark")
                                                .font(.title)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Section("Memo") {
                        TextField("Add your memo", text: $memo)
                    }
                    .padding()
                }
                // formStyle이 columns 속성이면 Section의 타이틀이 plain text 형태로 된다.
                .formStyle(.columns)
            }
            .navigationTitle("New Sticker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowingAddView.toggle()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        stickerStore.addSticker(Sticker(memo: trimMemo, colorIndex: colorIndex))
                        isShowingAddView.toggle()
                    }
                    .disabled(trimMemo.isEmpty)
                }
            }
        }
    }
}

struct AddingStickerVIew_Previews: PreviewProvider {
    static var previews: some View {
        AddingStickerView(stickerStore: StickerStore(), isShowingAddView: .constant(true))
    }
}
