//
//  entryViewController.swift
//  Cons_Project#7
//
//  Created by Tee Becker on 9/30/20.
//

import UIKit

class entryViewController: UIViewController {

    @IBOutlet var noteTitle: UITextField!
    @IBOutlet var noteDetail: UITextView!
    
    // closure that takes 2 parameters and returns void
    public var completion: ((String, String) -> Void)?
        
    var titleText: String! = ""
    var noteText: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTitle?.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
        
        titleText = noteTitle.text
        noteText = noteDetail.text
        
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapSave(){
        if let text = noteTitle.text, !text.isEmpty, !noteDetail.text.isEmpty{
            
            // if they are not empty, then call completion closure
            
            completion?(text, noteDetail.text)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
