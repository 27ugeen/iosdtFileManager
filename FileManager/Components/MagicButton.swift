//
//  MagicButton.swift
//  Navigation
//
//  Created by GiN Eugene on 20/11/21.
//

import Foundation
import UIKit

final class MagicButton: UIButton {
    
    private let onTap: () -> Void
    
    init(title: String, titleColor: UIColor, onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    @objc private func buttonTapped() {
        self.onTap()
    }
}
