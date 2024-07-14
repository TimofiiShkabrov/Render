//
//  MainView.swift
//  Render
//
//  Created by Тимофей Шкабров on 11/07/2024.
//

import SwiftUI

struct MainView: View {
    
    @State private var render = Render()
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack(spacing: 16) {
                        TextField("Введите Emoji или текст", text: $render.text)
                            .padding(4)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        
                        Button(action: {
                            render.hideKeyboard()
                            render.convertTextToPNG()
                        }) {
                            HStack {
                                Text("Рендер")
                                Image("Logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .disabled(render.text .isEmpty)
                    }
                    .padding(.bottom, 8)
                    
                    Text("Введите Emoji или текст к поле выше и нажмите кнопку Рендер")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                if let image = render.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(
                            Image("BackgroundPNG")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        )
                        .opacity(0.9)
                        .cornerRadius(16)
                } else {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(
                            Image("BackgroundPNG")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        )
                        .opacity(0.9)
                        .cornerRadius(16)
                }
                
                HStack {
                    Button (action: {
                        render.saveImageToGallery()
                    }) {
                        HStack {
                            Text("Сохранить")
                            Image(systemName: "square.and.arrow.down.fill")
                                .imageScale(.medium)
                                .symbolEffect(.bounce.down.byLayer)
                        }
                    }
                    
                    
                    
                }
                .disabled(render.image == nil)
                .padding()
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .alert(isPresented: $render.showSaveAlert) {
            Alert(title: Text("Результат сохранения"), message: Text(render.saveResultMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            render.hideKeyboard()
        }
    }
}

#Preview {
    MainView()
}
