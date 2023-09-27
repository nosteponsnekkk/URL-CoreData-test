//
//  OnboardingSeparator.swift
//  URL_Test
//
//  Created by Олег Наливайко on 26.09.2023.
//

import UIKit

class OnboardingSeparator: UIView {

    //MARK: - Enum
    public enum SeparatorStyle {
        case single
        case double
    }
    
    //MARK: - UI Elements
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "or"
        textLabel.font = UIFont.systemFont(ofSize: 18)
        textLabel.textColor = .black
        return textLabel
    }()
    private lazy var separatorLeft: UIView = {
        let separatorLeft = UIView()
        separatorLeft.backgroundColor = .lightGray
        return separatorLeft
    }()
    private lazy var separatorRight: UIView = {
        let separatorRight = UIView()
        separatorRight.backgroundColor = .lightGray
        return separatorRight
    }()
    
    //MARK: - INITs
    init(separatorStyle: SeparatorStyle, height: Int){
        super.init(frame: .zero)
        
        switch separatorStyle {
        case .single:
            addSubview(separatorLeft)
            separatorLeft.snp.makeConstraints { make in
                make.edges.equalTo(self)
                make.height.equalTo(height)
            }
        case .double:
            addSubview(textLabel)
            addSubview(separatorLeft)
            addSubview(separatorRight)
            makeConstraints(height)
        }
        
      
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Constraints
    private func makeConstraints(_ height: Int){
        textLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
        separatorLeft.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(textLabel.snp_leftMargin).offset(-20)
            make.centerY.equalTo(textLabel)
            make.height.equalTo(height)
        }
        separatorRight.snp.makeConstraints { make in
            make.right.equalTo(self)
            make.left.equalTo(textLabel.snp_rightMargin).offset(20)
            make.centerY.equalTo(textLabel)
            make.height.equalTo(height)
        }
    }
}
