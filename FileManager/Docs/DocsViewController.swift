//
//  ViewController.swift
//  FileManager
//
//  Created by GiN Eugene on 17/3/2022.
//

import UIKit

class DocsViewController: UIViewController {
    
    let docsViewModel: DocsViewModel
    
    let docsCellID = String(describing: DocsTableViewCell.self)
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    init(docsViewModel: DocsViewModel) {
        self.docsViewModel = docsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isToggleOn = UserDefaults.standard.bool(forKey: "toggle")
        docsViewModel.showDocsContent(isToggleOn: isToggleOn)
//        LoginViewModel().logOutUser { error in
//            print(String(describing: error?.localizedDescription))
//        }
        
        setupTableView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isToggleOn = UserDefaults.standard.bool(forKey: "toggle")
        docsViewModel.getSortedImages(isToggleOn: isToggleOn)
        tableView.reloadData()
    }
    
    @objc func addImage() {
        showImagePickerOption()
    }
}

extension DocsViewController {
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DocsTableViewCell.self, forCellReuseIdentifier: docsCellID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DocsViewController {
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func showImagePickerOption() {
        let alertVC = UIAlertController(title: "Pick a Photo", message: "Choose a picture from library or camera", preferredStyle: .actionSheet)
        //Image picker for camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            
            guard let self = self else {
                return
            }
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                let cameraImagePicker = self.imagePicker(sourceType: .camera)
                cameraImagePicker.delegate = self
                self.present(cameraImagePicker, animated: true)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        //Image picker for library
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            
            guard let self = self else {
                return
            }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension DocsViewController {
    func setupViews() {
        
        self.navigationItem.title = "Images"
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.done, target: self, action: #selector(addImage))
        self.navigationItem.setRightBarButtonItems([button], animated: true)
        
        view.backgroundColor = .white
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension DocsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            let isToggleOn = UserDefaults.standard.bool(forKey: "toggle")
            docsViewModel.saveImageToDocuments(chosenImage: image, isToggleOn: isToggleOn)
            tableView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension DocsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        docsViewModel.userImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: docsCellID, for: indexPath) as! DocsTableViewCell
        
        let creationDate = docsViewModel.sortedImages[indexPath.row].imageCreationDate
        
        cell.imgView.image = docsViewModel.sortedImages[indexPath.row].image
        cell.imageCreationDateLabel.text = String.getFormattedDate(date: creationDate)
        cell.imageSizeLabel.text = "\((docsViewModel.sortedImages[indexPath.row].imageSize)/1000)KB"
        return cell
    }
}

extension DocsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
