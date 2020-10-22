//
//  TBLabel.swift
//  Cons_Proj # 7-9
//
//  Created by Tee Becker on 10/21/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class TBLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(fontsize: CGFloat){
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontsize)
        configure()
    }
    
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
    }
}
