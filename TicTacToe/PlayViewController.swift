//
//  PlayViewController.swift
//  LocateFriend
//
//  Created by Sujata Tayade on 27/06/20.
//  Copyright © 2020 Sujata Tayade. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, UIGestureRecognizerDelegate {
    var imgtag = NSInteger()
    @IBOutlet weak var playview: UIView!
    @IBOutlet weak var superPlayView: UIView!
    @IBOutlet weak var winnerlabel: UILabel!
    var user1tagArr:[NSInteger]  = []
    var user2tagArr:[NSInteger]  = []
    var satisfiedTag:[NSInteger] = []
    var finishPlay   = NSInteger()
    var checkedCount = NSInteger()
    
    var user1img   = "Checked_Button"
    var user2img   = "Checked_green"
    
    var user1Name  = "Player 1"
    var user2Name  = "Player 2"
    
    var winColor   = UIColor.yellow
    var user1Color = UIColor.systemBlue
    var user2Color = UIColor.green
    
    
    func defaultSettings(){
        imgtag       = 0
        finishPlay   = 0
        checkedCount = 0
        winnerlabel.text      = user1Name + " Now Your Turn"
        winnerlabel.textColor = UIColor.systemBlue
    }
    @IBAction func resetplay(_ sender: Any) {
        //Start Game Again
        playOperations(collect: "reset")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defaultSettings();
        
        self.superPlayView.layer.shadowColor   = UIColor.white.cgColor
        self.superPlayView.layer.shadowOffset  = CGSize.zero
        self.superPlayView.layer.shadowOpacity = 0.5
        self.superPlayView.layer.shadowRadius  = 15
        self.superPlayView.layer.cornerRadius  = 10
        
        //Add tab gesture to all images
        for view1 in playview.subviews {
            view1.addGestureRecognizer(self.addtab())
        }
    }
    
    //Add Effect On Row Complete(After user won)
    func playOperations(collect: NSString){
        for view1 in playview.subviews {
            for view2 in view1.subviews {
                if view2 is UIImageView{
                    let translationimgv = view2 as! UIImageView
                    if(collect == "reset"){
                        //Start Game Again
                        translationimgv.image = nil
                        translationimgv.transform = CGAffineTransform(scaleX: 1, y: 1);
                        defaultSettings();
                    }
                    else{
                        if(translationimgv.image != nil){
                            if(collect == "collect"){
                                //Get All User Marked Boxes
                                let imagename = translationimgv.image?.accessibilityIdentifier ?? "No image";
                                if (imagename == user1img){
                                    user1tagArr.append(view2.tag)
                                }
                                else if (imagename == user2img){
                                    user2tagArr.append(view2.tag)
                                }
                                else{
                                    print("Not yet image assigned")
                                }
                            }
                            else if(collect == "effect"){
                                //After Finish Add Effect
                                var resetscaleval: CGFloat = 0.7
                                if (satisfiedTag.contains(view2.tag)){
                                    resetscaleval = 1.2
                                }
                                view2.transform = CGAffineTransform(scaleX: resetscaleval, y: resetscaleval);
                            }
                        }
                    }
                }
            }
        }
    }
    func addtab() -> UITapGestureRecognizer{
        let tabGesture = UITapGestureRecognizer(
          target: self,
          action: #selector(self.handleTab)
        )
        tabGesture.delegate = self
        return tabGesture
    }
    @IBAction func handleTab(_ gesture: UITapGestureRecognizer) {
        let translation = gesture.view!
//        guard let gestureView = gesture.view else {
//          return
//        }
        if(finishPlay == 0){
            for view2 in translation.subviews {
                if view2 is UIImageView{
                    let translationimgv = view2 as! UIImageView
                    if(translationimgv.image == nil){
                        checkedCount = checkedCount + 1
                        if(imgtag == 0){
                            translationimgv.image = UIImage(named: user1img)
                            winnerlabelChange(ltext: user2Name + " Now Your Turn", lcolor: user2Color)
                            imgtag = 1
                        }
                        else{
                            translationimgv.image = UIImage(named: user2img)
                            winnerlabelChange(ltext: user1Name + " Now Your Turn", lcolor: user1Color)
                            imgtag = 0
                        }
                        checkDone();
                    }
                }
            }
        }
    }
    
    //Check if any user won the game
    func checkDone(){
        user1tagArr = []
        user2tagArr = []
        
        //Get All User Marked Boxes
        playOperations(collect: "collect")
        
        if(self.checkUserWin(checkarr: user1tagArr)){
            winnerlabelChange(ltext: user1Name + " Won!", lcolor: winColor)
            finishPlay = 1;
        }
        else if(self.checkUserWin(checkarr: user2tagArr)){
            winnerlabelChange(ltext: user2Name + " Won!", lcolor: winColor)
            finishPlay = 1;
        }
        else if(checkedCount == 9){
            //When no one wins
            winnerlabelChange(ltext: "Draw!", lcolor: winColor)
        }
       
        
        if(finishPlay == 1){
            //After Finish Add Effect
            playOperations(collect: "effect")
        }
        
    }
    func winnerlabelChange(ltext:String, lcolor:UIColor){
        winnerlabel.text = ltext
        winnerlabel.textColor = lcolor
    }
    
    //Check if any user won the game
    func checkUserWin(checkarr: [NSInteger]) -> (Bool){
        // this is our array of arrays
        var groups = [[NSInteger]]()
        groups = [[100,101,102], [100,200,300], [100,201,302], [101,201,301], [102,202,302], [102,201,300], [200,201,202], [300,301,302]]
        
        for i in 0...groups.count-1{
            satisfiedTag = groups[i]
            if satisfiedTag.allSatisfy(checkarr.contains){
                return true;
            }
        }
        satisfiedTag = []
        return false;
    }
    
}
