//
//  ViewController.swift
//  Project 25
//
//  Created by Tee Becker on 9/17/20.
//  Peer-to-Peer app, sharing selfies :)

//Multipeer connectivity requires four new classes:

//- MCSession - manager class that handles all multipeer connectivity for us
//- MCPeerID - identifies each user uniquely in a session
//- MCAdvertiserAssistant - used when CREATE a session, telling others our existance and handling invitations
//- MCBrowserViewController - used when LOOKING for sessions, showing users who are nearby and letting them join

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPhoto))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        // Do any additional setup after loading the view.
        
        // encryption required, to ensure data transferred is kept safe
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    @objc func importPhoto(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func showConnectionPrompt(){
        
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinsession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else{return}
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // additional code added to send image data to peers after we take them
        //1. check for active session available that we can use
        guard let mcSession = mcSession else{return}
        
        //2. check if there are any peers to send in
        if mcSession.connectedPeers.count > 0{
            
            //3. convert the new image to a data object
            if let imageData = image.pngData(){
                
                //4. send it to all peers, ensuring that it gets delivered
                do{
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch{
                    //5. show an error message if there is an problema
                    let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ok", style: .default))
                    present(ac, animated: true)
                }
            }
        }
        
    }
    
    func startHosting(action: UIAlertAction){
        guard let mcSession = mcSession else{return}
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "teeks-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinsession(action: UIAlertAction){
        guard let mcSession = mcSession else {return}
        let mcBrowser = MCBrowserViewController(serviceType: "teeks-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // This is new. Using tag of imageview. All UIView subclasses have a method called (viewWithTag) which search for views or subviews inside itself with that tag number.
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //using "ImageView" identifier, to find any subview within itself with a tag 1000. then typecast that as UIImageview.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        if let imageview = cell.viewWithTag(1000) as? UIImageView{
            imageview.image = images[indexPath.item]
        }
        return cell
    }
    
    
    // the two protocols combined above have 7 required methods we need to implement.
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //when  a user connects or disconnects from our session, this is called so we know what has changed . could be useful to print out diagnostics for debugging.
        
        switch state{
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            print("Teek's iphone has disconnected")
        @ unknown default:
            print("Unknown state: \(peerID.displayName)")
        }
        
    }
    
    //once images arrive at each peer, this gets called, and we can create a UIimage from it and then add to our images array
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // when receive data it might not be on the main thread so we bring it to the main thread
        DispatchQueue.main.async {[weak self] in
            if let image = UIImage(data: data){
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //no code necessary
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //no code necessary
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //no code necessary
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        //trivial code necessary
        // called when finishes successfully
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        //trivial code necessary
        // called when user cancells
        dismiss(animated: true)
    }
    
    // end of required methods
}

