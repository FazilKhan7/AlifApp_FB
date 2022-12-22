//
//  DetailsDhikrViewController.swift
//  PrayTime
//
//  Created by Bakhtiyarov Fozilkhon on 12.12.2022.
//

import UIKit
import AVFoundation

protocol DetailsDhikrViewControllerDelegate: AnyObject {
    func changeTheCounter(info: String)
}

class DetailsDhikrViewController: UIViewController, AVAudioPlayerDelegate {
    
    weak var delegate: DetailsDhikrViewControllerDelegate?
    var object: DhikrModel?
    
    @IBOutlet weak var arabic: UILabel!
    @IBOutlet weak var englishMean: UILabel!
    @IBOutlet weak var dismiss: UIButton!
    @IBOutlet weak var counterClick: UILabel!
    @IBOutlet weak var soundImage: UIButton!
    
    var arabDhikr = ""
    var engDhikr = ""
    var audioDhikr = ""
    var countAllDhikres = 0
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arabic.text = (arabDhikr)
        englishMean.text = (engDhikr)
        countAllDhikres = 0
        setUpLabelTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.stop()
    }
    
    @IBAction func doDismiss(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "main") else{return}
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func soundOfDhikres(_ sender: Any) {
        soundImage.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        playSound(buttonType: audioDhikr)
        
        if soundImage.imageView?.image == UIImage(systemName: "pause.circle.fill") {
            soundImage.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            player.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        soundImage.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
    
    func playSound(buttonType: String) {
        
        guard let url = Bundle.main.url(forResource: buttonType, withExtension: "m4a") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.delegate = self
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var count = 0
    @objc func labelTapped(_ sender: UITapGestureRecognizer){
        count += 1
        counterClick.text = String(count)
        delegate?.changeTheCounter(info: String(count))
    }
    
    func setUpLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        self.counterClick.isUserInteractionEnabled = true
        self.counterClick.addGestureRecognizer(labelTap)
    }
    
    @IBAction func appearTableView(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Dhikr") else {fatalError("Unable page")}
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        self.present(navController, animated: true)
    }
}
