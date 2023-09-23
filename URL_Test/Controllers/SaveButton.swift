//
//  SaveButton.swift
//  URL_Test
//
//  Created by Олег Наливайко on 23.09.2023.
//

import UIKit

class SaveButton: UIButton {
    
    //MARK: - Enum for modes

    private enum ButtonMode {
        case saved
        case notSaved
    }
    
    //MARK: - Original transform for animation
    private var originalTransform: CGAffineTransform = .identity

    //MARK: - Inits
    init(){
        super.init(frame: .zero)
        setupButton()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
    private func setupButton(){
        backgroundColor = .transparentWhite
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    private func setMode(mode: ButtonMode){
        
        switch mode {
        case .saved:
            DispatchQueue.main.async { [unowned self] in
                self.setImage(UIImage(named: "saved")?.resize(to: CGSize(width: 33, height: 33)), for: .normal)
                self.tintColor = .primary
                self.isSaved = true
            }
            
            
        case .notSaved:
            DispatchQueue.main.async { [unowned self] in
                self.setImage(UIImage(named: "saved.light")?.resize(to: CGSize(width: 33, height: 33)), for: .normal)
                self.tintColor = .black
                self.isSaved = false
            }
            
        }
        
    }
  
    //MARK: - Interfaces
    public func checkIsSaved(_ title: String){
        CoreDataManager.shared.checkIsArticleSaved(title) { [unowned self] isSaved in
            if isSaved {
                self.setMode(mode: .saved)
            } else {
                self.setMode(mode: .notSaved)
            }
        }
    }
    public var isSaved = false
    @objc private func buttonTapped() {
            UIView.animate(withDuration: 0.1, animations: { [unowned self] in
                self.transform = self.originalTransform.scaledBy(x: 0.9, y: 0.9)
            }) { _ in
                UIView.animate(withDuration: 0.1) { [unowned self] in
                    self.transform = self.originalTransform
                }
            }
            
           
        }
    
}
