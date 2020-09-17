import UIKit

//1. Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.

extension UIView{
    func bounceOut(_ duration: Double){
        
        UIView.animate(withDuration: duration) {[weak self] in
            
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

//to apply. add a button to navigation bar (not shown here, see project 15)

navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(action))

//set selector to be below:

@objc func action(){
    self.view.bounceOut(3)
}


//2. Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.

extension Int{
    
    func times(_ action: () ->Void) {
        guard self > 0 else{return}
        
        for _ in 0..<self {
            action()
        }
    }
}

5.times {
    print("hello world")
}


//3. Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!

extension Array where Element: Comparable{
    mutating func remove(item: Element){
        if let index = self.firstIndex(of: item){
            self.remove(at: index)
        }
    }
}

var numbers = [1,2,3,4,5]
numbers.remove(item: 3)





