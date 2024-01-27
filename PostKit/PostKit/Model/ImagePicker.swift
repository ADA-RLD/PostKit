//
//  ImagePicker.swift
//  PostKit
//
//  Created by Kim Andrew on 1/24/24.
//

import Foundation
import UIKit
import SwiftUI
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: [UIImage]
    @Binding var imageUrl: URL?
    @Binding var fileName: String?
    
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage.append(image)
            }
            
            if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                parent.imageUrl = imageUrl
                parent.fileName = imageUrl.lastPathComponent
                print(parent.imageUrl)
                print(parent.fileName)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
