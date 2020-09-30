//
//  ViewController.swift
//  Project 27
//
//  Created by Tee Becker on 9/24/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var Redraw: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
        Redraw.setTitle("Redraw", for: .normal)
        Redraw.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(Redraw)
        Redraw.addTarget(self, action: #selector(redrawTapped), for: .touchUpInside)
        
        autoLayoutConstraint()
        view.addSubview(imageView)
        
        // This is case 0
        drawSmiley()
    }
    
    func autoLayoutConstraint(){
        NSLayoutConstraint.activate([
            Redraw.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            Redraw.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    @objc func redrawTapped(_sender: Any){
        // do stuff
        currentDrawType += 1
        
        if currentDrawType > 6{
            currentDrawType = 0
        }
        
        switch currentDrawType{
        case 0:
            drawSmiley()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawRectangle()
        default:
            break
        }
    }
    
    func drawSmiley(){
        //create renderer?
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 500, height: 500))
        
        // create img
        let img = renderer.image { (ctx) in
           
            let firstRect = CGRect(x: 50, y: 0, width: 10, height: 10)
            let secondRect = CGRect(x: 70, y: 0, width: 10, height: 10)
            
            let rectangle = CGRect(x: 50, y: 25, width: 30, height: 10)
            ctx.cgContext.addEllipse(in: rectangle)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//            ctx.cgContext.setLineWidth(5)
            
            ctx.cgContext.addEllipse(in: firstRect)
            ctx.cgContext.addEllipse(in: secondRect)
            
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawImagesAndText(){
        //5
        //1. create renderer
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { (ctx) in
            //2. define paragraph style to align text to center
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            //3. create attribute dictionary containing that style and font
            let attribute:[NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            //4. wrap the attribute inside NSAttributedString
            let string = "WHO TOOK MY CHEESE"
            let attributedString = NSAttributedString(string: string, attributes: attribute)
            
            //5. load an image from project and draw it to context ( need to give it a rectangle)
            attributedString.draw(with: CGRect(x: 70, y: 70, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
            
        }
        imageView.image = img
    }
    
    func drawLines(){
        //4
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 500, height: 500))
        let img = renderer.image { (ctx) in
            ctx.cgContext.translateBy(x: 250, y: 250)
            
            var first = true
            var length: CGFloat = 250
            
            for _ in 0..<250{
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first{
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
            ctx.cgContext.strokePath()
            ctx.cgContext.setLineWidth(3)
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares(){
        //3
        //transform a context before drawing and stroke a path without filling it
        //translateBy - moves the current transformation Matrix
        //rotateBy - rotates the current transformation Matrix
        //strokePath - strokes the path with specified line width, default is 1
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { (ctx) in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotation = 25
            let amount = Double.pi / Double(rotation)
            
            for _ in 0 ..< rotation{
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    func drawCheckerBoard(){
        //2
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        //fill directly with the color
        let img = renderer.image { (ctx) in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            
            // we only drew the black ones so the white blocks are actually transparent
            for row in 0..<8{
                for col in 0..<8{
                    if (row + col) % 2 == 0{
                        ctx.cgContext.fill(CGRect(x: col*64, y: row*64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    
    func drawCircle(){
        //1
        // literally the same as drawRectangle except for 1 line, it draws a eclipse inside the specified rectangle
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let drawingImg = renderer.image { (ctx) in
            let rectangle = CGRect(x: 0, y: 0, width: 400, height: 400).insetBy(dx: 100, dy: 100)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            ctx.cgContext.setLineWidth(16)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = drawingImg
    }
    
    func drawRectangle(){
        //0
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let drawingImg = renderer.image { (ctx) in
            //drawing code
            //define the rectangle
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.yellow.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle) // adds the rectangle to the current path to be drawn
            
            //using what state
            ctx.cgContext.drawPath(using: .fillStroke) // draws the path using state we configured
        }
        
        imageView.image = drawingImg
    }
}

