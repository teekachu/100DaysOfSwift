//
//  TBButtonsView.swift
//  Cons_Proj # 7-9
//
//  Created by Tee Becker on 10/21/20.
//  Copyright © 2020 TeeksCode. All rights reserved.
//

import UIKit

class TBButtonsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}

extension UIView{
    public var viewWidth: CGFloat {
        return self.bounds.size.width
    }
    
    public var viewHeight: CGFloat {
        return self.bounds.size.height
    }
    
}
