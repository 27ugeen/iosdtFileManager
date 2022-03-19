//
//  DocsViewModel.swift
//  FileManager
//
//  Created by GiN Eugene on 18/3/2022.
//

import Foundation
import UIKit

protocol DocsViewModelOutputProtocol {
    func showDocsContent()
    func saveImageToDocuments(chosenImage: UIImage)
}

class DocsViewModel: DocsViewModelOutputProtocol {
    
    var documentsUrl: URL?
    var content: [URL]?
    var userImages: [UIImage] = []
    
    func showDocsContent() {
        do {
            documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            if let unwrappeddDocumentsUrl = documentsUrl {
                content = try FileManager.default.contentsOfDirectory(at: unwrappeddDocumentsUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            }
        }
        catch let error as NSError {
            print("Error is: \(error.localizedDescription)")
        }
        
        if let unwrappedContent = content {
            for file in unwrappedContent {
                do {
                    let imageData = try Data(contentsOf: file)
                    
                    if let image = UIImage(data: imageData) {
                        userImages.append(image)
                    }
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveImageToDocuments(chosenImage: UIImage) {
        let data = chosenImage.jpegData(compressionQuality: .zero)
        
        if let unwrappedDocumentsUrl = documentsUrl {
            let fileUrl = unwrappedDocumentsUrl.appendingPathComponent(String.random())
            FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
            
            userImages.append(chosenImage)
        }
    }
}

extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
