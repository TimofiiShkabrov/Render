//
//  MainView.swift
//  Render
//
//  Created by Тимофей Шкабров on 11/07/2024.
//

import SwiftUI

struct MainView: View {
    
    @State private var render = Render()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    TextField("Введите Emoji или текст", text: $render.text)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.bottom, 16)
                    VStack {
                        ColorPicker("Цвет текста:", selection: $render.textColor)
                        HStack {
                            Text("Размер:")
                            Slider(value: $render.fontSize, in: 1...CGFloat(Int(UIScreen.main.bounds.width * 0.8)))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    
                    Button(action: {
                        render.hideKeyboard()
                        render.showSaveAlert = false
                        render.convertTextToPNG()
                    }) {
                        HStack {
                            Text("Рендер")
                                .foregroundStyle(.white)
                            Image(systemName: "sparkles")
                                .imageScale(.large)
                        }
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .disabled(render.text .isEmpty)
                }
                .padding(.top, 16)
                .padding(.bottom, 16)

                HStack {
                    if render.showSaveAlert {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
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
                                    .foregroundStyle(.blue)
                                    .symbolEffect(.wiggle.backward.byLayer)
                                    .imageScale(.large)
                                Text("Введите Emoji или текст к поле выше\n и нажмите кнопку Рендер")
                                    .multilineTextAlignment(.center)
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 16.0, height: UIScreen.main.bounds.width - 16.0)
                .background(Image("PNGBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.9)
                    .cornerRadius(16))
                .padding(.bottom, 16)
                
                HStack {
                    if let fileURL = render.createPNGFile() {
                        ShareLink(item: fileURL, preview: SharePreview("Rendered Image", image: Image(uiImage: render.image!))) {
                            HStack {
                                Text("Поделиться")
                                Image(systemName: "square.and.arrow.up.fill")
                                    .imageScale(.large)
                                    .symbolEffect(.breathe.plain.byLayer)
                            }
                        }
                    } else {
                        HStack {
                            Text("Поделиться")
                            Image(systemName: "square.and.arrow.up.fill")
                                .imageScale(.large)
                                .symbolEffect(.breathe.plain.byLayer)
                        }
                        .foregroundStyle(colorScheme == .dark ? Color(#colorLiteral(red: 0.2745094299, green: 0.274510026, blue: 0.2873998582, alpha: 1)) : Color(#colorLiteral(red: 0.7725487947, green: 0.772549212, blue: 0.7811570764, alpha: 1)))
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
