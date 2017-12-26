//
//  ViewController.swift
//  ImageRecognitionCoreML
//
//  Created by Mohammad Azam on 9/4/17.
//  Copyright © 2017 Mohammad Azam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pictureImageView :UIImageView!
    @IBOutlet weak var titleLabel :UILabel!
    
    private var model :my_model = my_model()

    let pathForImages = Bundle.main.bundlePath
    let extensionsForImages = ["jpeg", "jpg", "png"]

    lazy var images: [String] = {
        guard let content = try? FileManager.default.contentsOfDirectory(atPath: pathForImages) else { return [] }
        return content.filter { extensionsForImages.contains( URL(fileURLWithPath: $0).pathExtension.lowercased() ) }
    }()

    var index = 0

    @IBAction func nextButtonPressed() {
        
        if index > self.images.count - 1 {
            index = 0
        }
        
        let img = UIImage(named: images[index])
        self.pictureImageView.image = img
        
        let resizedImage = img?.resizeTo(size: CGSize(width: 224, height: 224))
        
        let buffer = resizedImage?.toBuffer()
        
        let prediction = try! self.model.prediction(input: my_modelInput(input__0: buffer!))
        
        //let prediction = try! self.model.prediction(image: buffer!)
        
        self.titleLabel.text = prediction.classLabel
        
        index = index + 1
    }

}

