//
//  TBButton.swift
//  Cons_Proj # 7-9
//
//  Created by Tee Becker on 10/21/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class TBButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(title: String, fontsize: CGFloat){
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontsize)
        configure()
    }
    
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.black, for: .normal)
    }

}
