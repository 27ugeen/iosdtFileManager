//
//  DocsViewModel.swift
//  FileManager
//
//  Created by GiN Eugene on 18/3/2022.
//

import Foundation
import UIKit

protocol DocsViewModelOutputProtocol {
    func saveImageToDocuments(chosenImage: UIImage)
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
                }
            } catch let error as NSError {
                print("Error is: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteImageFromDocuments(removableImage: ImageFile, index: Int) {
        if let unwrappedDocumentsUrl = documentsUrl {
            
            if content != nil {
                let fileUrl = unwrappedDocumentsUrl.appendingPathComponent(removableImage.imageName)

                    if FileManager.default.fileExists(atPath: fileUrl.path) {
                        do {
                            try FileManager.default.removeItem(at: fileUrl)
                            print("Image \(removableImage.imageName) has been deleted!")
                        } catch let error as NSError {
                            print("Error is: \(error.localizedDescription)")
                        }
                    }
                userImages.remove(at: index)
            }
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
    
    static func getFormattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.setLocalizedDateFormatFromTemplate("dd-MM-yyyy HH:mm")
        return formatter.string(from: date)
    }
}
