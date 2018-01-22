//
//  SplashScreenViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 1/10/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tabBarBlue()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
        
        playAudio(sound: "glasses", ext: "wav")
        setupSplashScreen()
        
    }
    @objc fileprivate func setupSplashScreen() {
        let animationView = LOTAnimationView.init(name: "drink")
//        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 100, width: view.frame.size.width , height: 550)
        animationView.contentMode = .scaleAspectFit
//        animationView.loopAnimation = true
        view.addSubview(animationView)
        animationView.play()
    }
    
    @objc func splashTimeOut(sender : Timer){
        let appvar = UIApplication.shared.delegate as! AppDelegate
        appvar.window?.rootViewController = MainTabBarController()

        
    }
    var bombSoundEffect: AVAudioPlayer?
    func playAudio(sound: String, ext: String) {
        let url = Bundle.main.url(forResource: sound, withExtension: ext)!
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            guard let bombSound = bombSoundEffect else { return }
            bombSound.prepareToPlay()
            bombSound.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}
