//
//  DocsViewModel.swift
//  FileManager
//
//  Created by GiN Eugene on 18/3/2022.
//

import Foundation
import UIKit

protocol DocsViewModelOutputProtocol {
    func showDocsContent(isToggleOn: Bool)
    func saveImageToDocuments(chosenImage: UIImage, isToggleOn: Bool)
}

struct ImageFile {
    let image: UIImage
    let imageName: String
    let imageSize: Int
    let imageCreationDate: Date
}

class DocsViewModel: DocsViewModelOutputProtocol {
    
    var documentsUrl: URL?
    var content: [URL]?
    var userImages: [ImageFile] = []
    var sortedImages: [ImageFile] = []
    
    func showDocsContent(isToggleOn: Bool) {
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
            for fileUrl in unwrappedContent {
                var fileSize: Int?
                var creationDate: Date?
                
                if FileManager.default.fileExists(atPath: fileUrl.path) {
                    do {
                        let attributes = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
                        fileSize = attributes[.size] as? Int
                        creationDate = attributes[.creationDate] as? Date
                    } catch let error as NSError {
                        print("Error is: \(error.localizedDescription)")
                    }
                }
                do {
                    let imageData = try Data(contentsOf: fileUrl)
                    
                    if let image = UIImage(data: imageData) {
                        let newImage = ImageFile.init(image: image, imageName: fileUrl.lastPathComponent, imageSize: fileSize ?? 0, imageCreationDate: creationDate ?? Date())
                        
                        userImages.append(newImage)
                        self.getSortedImages(isToggleOn: isToggleOn)
                    }
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveImageToDocuments(chosenImage: UIImage, isToggleOn: Bool) {
        let data = chosenImage.jpegData(compressionQuality: .zero)
        
        if let unwrappedDocumentsUrl = documentsUrl {
            let fileUrl = unwrappedDocumentsUrl.appendingPathComponent(String.random())
            FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
            
            var fileSize: Int?
            var creationDate: Date?
            
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                do {
                    let attributes = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
                    fileSize = attributes[.size] as? Int
                    creationDate = attributes[.creationDate] as? Date
                } catch let error as NSError {
                    print("Error is: \(error.localizedDescription)")
                }
            }
            do {
                let imageData = try Data(contentsOf: fileUrl)
                
                if let image = UIImage(data: imageData) {
                    let newImage = ImageFile.init(image: image, imageName: fileUrl.lastPathComponent, imageSize: fileSize ?? 0, imageCreationDate: creationDate ?? Date())
                    
                    userImages.append(newImage)
                    self.getSortedImages(isToggleOn: isToggleOn)
                }
            } catch let error as NSError {
                print("Error is: \(error.localizedDescription)")
            }
        }
    }
    
    func getSortedImages(isToggleOn: Bool) {
        if isToggleOn {
            sortedImages = userImages.sorted {
                $0.imageName < $1.imageName
            }
        } else {
            sortedImages = userImages.sorted {
                $0.imageName > $1.imageName
            }
        }
    }
}
