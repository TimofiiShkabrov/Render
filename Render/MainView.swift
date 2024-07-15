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
                HStack(spacing: 16) {
                    TextField("Введите Emoji или текст", text: $render.text)
                        .padding(4)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    Button(action: {
                        render.hideKeyboard()
                        render.showSaveAlert = false
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
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                HStack {
                    if render.showSaveAlert {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .symbolEffect(.wiggle.backward.byLayer)
                                .imageScale(.large)
                            Text("Сохронено!")
                                .foregroundStyle(.black)
                        }
                    } else {
                        if let image = render.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            VStack {
                                Image(systemName: "pencil.line")
                                    .foregroundColor(.blue)
                                    .symbolEffect(.wiggle.backward.byLayer)
                                    .imageScale(.large)
                                Text("Введите Emoji или текст к поле выше и нажмите кнопку Рендер")
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 16.0, height: UIScreen.main.bounds.width - 16.0)
                .background(Image("BackgroundPNG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.9)
                    .cornerRadius(16))
                .padding(.bottom, 16)
                
                ColorPicker("Цвет текста:", selection: $render.textColor)
                HStack {
                    Text("Размер текста:")
                    Slider(value: $render.fontSize, in: 1...CGFloat(Int(UIScreen.main.bounds.width)))
                }
                
                HStack {
                    if let fileURL = render.createPNGFile() {
                        ShareLink(item: fileURL, preview: SharePreview("Rendered Image", image: Image(uiImage: render.image!))) {
                            HStack {
                                Text("Поделиться")
                                Image(systemName: "square.and.arrow.up.fill")
                                    .imageScale(.medium)
                                    .symbolEffect(.bounce.down.byLayer)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button (action: {
                        render.saveImageToGallery()
                    }) {
                        HStack {
                            Text("Сохранить")
                            Image(systemName: "square.and.arrow.down.fill")
                                .imageScale(.large)
                                .symbolEffect(.breathe.plain.byLayer)
                        }
                    }
                }
                .disabled(render.image == nil)
                .padding()
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .onTapGesture {
            render.hideKeyboard()
        }
    }
}

#Preview {
    MainView()
}
