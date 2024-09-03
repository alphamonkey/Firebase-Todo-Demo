//
//  ImagePicker.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 9/3/24.
//

import SwiftUI

struct ImagePicker:UIViewControllerRepresentable {
    @Binding var selectedImage:UIImage
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator
        return imagePicker
        
    }
    
   
}

final class Coordinator:NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent:ImagePicker
    
    init(_ parent:ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            parent.selectedImage = image
        }
    }
}
