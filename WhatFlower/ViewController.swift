//
//  ViewController.swift
//  WhatFlower
//
//  Created by Thiago Antonio Ramalho on 17/12/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RequestDelegate {

    private let imagePickerController =  UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
    private lazy var requestManager: RequestManager = {
        let requestManager = RequestManager()
        requestManager.delegate = self
        return requestManager
    }()
    
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
            
            guard let ciImage = CIImage(image: safeImage) else {
                  fatalError("is not possible convert UIImage into CIImage")
              }
              
            detect(image: ciImage)
        }
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    private func detect(image: CIImage) {
    
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(contentsOf: FlowerClassifier.urlOfModelInThisBundle).model) else {
            fatalError("Load core model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            
            var finalTitle = "Unknow Flower"
            
            if let firstResult = results.first {
                finalTitle = firstResult.identifier.capitalized
                self.requestManager.get(flowerName: finalTitle)
            }
            
            self.navigationItem.title = finalTitle
        }
        
        guard let cgImage = image.cgImage else {
            fatalError("image do not have cgImage")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    internal func success(description: String) {
        label.text = description
    }
}

