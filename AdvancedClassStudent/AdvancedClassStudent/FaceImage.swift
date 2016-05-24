//
//  Photo.swift
//  SwiftPhotoGallery
//
//  Created by Prashant on 12/09/15.
//  Copyright (c) 2015 PrashantKumar Mangukiya. All rights reserved.
//

import Foundation

class FaceImage {

    var faceId: String!
    var image: UIImage!
    init(faceId: String, image: UIImage){
        self.faceId = faceId
        self.image = image
    }

}