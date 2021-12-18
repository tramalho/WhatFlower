//
//  ViewController.swift
//  WhatFlower
//
//  Created by Thiago Antonio Ramalho on 17/12/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let imagePickerController =  UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
    }

    @IBAction func tappedCamera(_ sender: UIBarButtonItem) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let safeImage = info[.editedImage] as? UIImage {
            imageView.image = safeImage
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
}

