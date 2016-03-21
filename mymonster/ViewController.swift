//
//  ViewController.swift
//  mymonster
//
//  Created by Tyree Stevenson on 1/30/16.
//  Copyright © 2016 Tyree Stevenson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var skull1: UIImageView!
    @IBOutlet weak var skull2: UIImageView!
    @IBOutlet weak var heartImg: Drag!
    @IBOutlet weak var skull3: UIImageView!
    @IBOutlet weak var foodImg: Drag!
    @IBOutlet weak var monsterImg: Monsterimg!
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
     var penalities = 0
     var timer: NSTimer!
     var monsterHappy = false
    var currentItem: UInt32 = 0
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxskull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skull1.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ItemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        startTimer()
        changeGameState()
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxskull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxskull.prepareToPlay()
        }catch let err as NSError{
            print(err.debugDescription)
            
        }
    }
    func ItemDroppedOnCharacter(notif: AnyObject) {
       monsterHappy = true
        startTimer()
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        if currentItem == 0 {
            sfxHeart.play()
        }
        else {
            sfxBite.play()
        }
        

    }
    func startTimer() {
        if timer != nil {
            timer.invalidate()
            
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    func changeGameState() {
        penalities++
        
        if !monsterHappy {
            if penalities == 1 {
                skull1.alpha = OPAQUE
                skull2.alpha = DIM_ALPHA
            }
            else if penalities == 2 {
                skull2.alpha = OPAQUE
                skull3.alpha = DIM_ALPHA
            }
            else if penalities >= 3 {
                skull3.alpha = OPAQUE
            }
            else {
                skull1.alpha = DIM_ALPHA
                skull2.alpha = DIM_ALPHA
                skull3.alpha = DIM_ALPHA
            }
            if penalities >= MAX_PENALTIES {
                gameOver()
            }
        }
        let rand = arc4random_uniform(2)
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        currentItem = rand
        monsterHappy = false
        
  }
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
}





