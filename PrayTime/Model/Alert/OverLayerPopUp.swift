//
//  OverLayerPopUp.swift
//  PrayTime
//
//  Created by Nurdaulet on 14.12.2022.
//

import UIKit

class OverLayerPopUp: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var letter: UILabel!
    @IBOutlet weak var pronunciation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        // Do any additional setup after loading the view.
    }
    
    
    init() {
        super.init(nibName: "OverLayerPopUp", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 10
    }
    
    func appear(sender: UIViewController, title: String, subtitle: String) {
        sender.present(self, animated: true) {
            self.letter.text = title
            self.pronunciation.text = subtitle
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 1, delay: 0.2) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    
}
