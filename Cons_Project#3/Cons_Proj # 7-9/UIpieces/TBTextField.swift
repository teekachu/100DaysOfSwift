//
//  TBTextField.swift
//  Cons_Proj # 7-9
//
//  Created by Tee Becker on 10/21/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class TBTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confugure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(fontsize: CGFloat){
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontsize, weight: .regular)
        confugure()
    }
    
    
    private func confugure(){
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        textAlignment = .center
        textColor = .black
    }
}
