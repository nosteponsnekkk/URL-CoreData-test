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
        addTapAnimations()
    }
    private func setSavedMode(){
        DispatchQueue.main.async { [unowned self] in
            self.setImage(UIImage(named: "saved")?.resize(to: CGSize(width: 33, height: 33)), for: .normal)
            self.tintColor = .primary
            self.isSaved = true
        }
    }
    private func setNotSavedMode(){
        DispatchQueue.main.async { [unowned self] in
            self.setImage(UIImage(named: "saved.light")?.resize(to: CGSize(width: 33, height: 33)), for: .normal)
            self.tintColor = .black
            self.isSaved = false
        }
    }
    private func setMode(mode: ButtonMode){
    
        switch mode {
        case .saved:
            setSavedMode()
        case .notSaved:
           setNotSavedMode()
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
    public func toggleMode(){
        switch isSaved {
        case true:
            setNotSavedMode()
        case false:
            setSavedMode()
        }
    }
  
    
}
