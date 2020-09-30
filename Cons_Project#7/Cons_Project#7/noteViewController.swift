//
//  noteViewController.swift
//  Cons_Project#7
//
//  Created by Tee Becker on 9/30/20.
//

import UIKit

class noteViewController: UIViewController {

    @IBOutlet var noteTitle: UITextField!
    @IBOutlet var noteDetail: UITextView!
    
    public var titleToLoad: String = ""
    public var detailToLoad : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTitle.text = titleToLoad
        noteDetail.text = detailToLoad
        
        // Do any additional setup after loading the view.
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
