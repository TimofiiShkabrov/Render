//
//  MainViewModel.swift
//  Render
//
//  Created by Тимофей Шкабров on 11/07/2024.
//

import Foundation
import Observation
import PhotosUI
import SwiftUI

@Observable
class Render {
    
    var text = ""
    var image: UIImage?
    var showSaveAlert = false
    var saveResultMessage = ""
    var fontSize: CGFloat = 200
    var textColor = Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1)
    
    func convertTextToPNG() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Установка цвета фона
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        // Установка цвета текста
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor(textColor)
        ]
        
        var textSize = (text as NSString).size(withAttributes: attributes)
        
        // Уменьшение размера текста, если он не помещается
        while textSize.width > size.width - 20 {
            fontSize -= 1
            attributes[.font] = UIFont.systemFont(ofSize: fontSize)
            textSize = (text as NSString).size(withAttributes: attributes)
        }
        
        // Центрируем текст
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        (text as NSString).draw(in: textRect, withAttributes: attributes)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        self.image = image
    }
    
    func saveImageToGallery() {
        guard let image = image, let pngData = image.pngData() else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: pngData, options: options)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.saveResultMessage = "Изображение успешно сохранено в галерею!"
                        } else {
                            self.saveResultMessage = "Ошибка при сохранении изображения: \(error?.localizedDescription ?? "Неизвестная ошибка")"
                        }
                        self.showSaveAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.saveResultMessage = "Нет доступа к фото библиотеке."
                    self.showSaveAlert = true
                }
            }
        }
    }
    
    func createPNGFile() -> URL? {
        guard let image = image, let pngData = image.pngData() else { return nil }
        
        let fileName = "RenderedImage.png"
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try pngData.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving PNG file: \(error)")
            return nil
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
