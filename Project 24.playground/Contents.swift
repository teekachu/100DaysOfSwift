

import UIKit
import PlaygroundSupport

extension String{
    
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else{ return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else{return self}
        return String(self.dropLast(suffix.count))
    }
    
    func capitalizeFirst() -> String {
        guard let firstLetter = self.first else{ return ""}
        return firstLetter.uppercased() + self.dropFirst()
    }
    
    //exercise 1. create extension to add withPrefix() method
    func withPrefix(_ prefix: String) -> String{
        // first check if it has prefix
        guard self.hasPrefix(prefix) else{
            // if it doesn't, add prefix
            print("adding to string...")
            return "\(prefix)" + " " + self
            
        }
        //if it does, return self
        print("already have this prefix")
        return self
    }
    
    //exercise 2. create extension that adds an isNumeric property and returns bool if string have a number.
    func isNumeric() -> Bool {
        
        for char in self{
            if Int(String(char)) != nil || Double(String(char)) != nil{
                return true
            }
        }
        
        return false
    }
    
    //exercise 3. adds a lines property that returns an array of all lines in a string. so " this\nis\na\ntest" should return ["this", "is", "a", "test"]
    
    func lines() -> [String] {
        guard !self.isEmpty else {return [""]}
        
        return self.components(separatedBy: "\n")
    }
}


//testing exercise 1:
let pet = "DOG CAT RABBITS"
pet.withPrefix("COW")
pet.withPrefix("DOG")


//testing exercise 2:
let withNumber = "I am 21 years old"
let withMoreNumber = " It is 2020 this year"
let withoutNumber = " I love China"

withNumber.isNumeric()
withoutNumber.isNumeric()
withMoreNumber.isNumeric()


//testing exercise 3:
let sentence = "this\nis\na\ntest"
sentence.lines()

//deletePrefix example
pet.deletePrefix("DOG")

//deleteSuffix example
pet.deleteSuffix("BITS")

//capitalizeFirst
let lowercase = "apocalypse world"
lowercase.capitalizeFirst()
lowercase.capitalized

let lowerCased = "hello my name is teeks"
lowerCased.capitalized //capitalize the first letter of every word
lowerCased.capitalizeFirst() // only capitalize the first letter of first word



//continuation with lecture
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.systemTeal,
    .font: UIFont.boldSystemFont(ofSize: 24)
    
]

let attributedPetString = NSAttributedString(string: pet, attributes: attributes)

let attributedString2 = NSMutableAttributedString(string: pet)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 36), range: NSRange(location: 10, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 55), range: NSRange(location: 14, length: 1))

attributedString2.addAttribute(.foregroundColor, value: UIColor.green, range: NSRange(location: 5, length: 3))
