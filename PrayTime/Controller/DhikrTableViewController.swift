//
//  DhikrTableViewController.swift
//  PrayTime
//
//  Created by Bakhtiyarov Fozilkhon on 12.12.2022.
//

import UIKit

class DhikrTableViewController: UIViewController {
        
    var objects = [DhikrModel(img: UIImage(systemName: "1.circle.fill")!, name: "Subhanaalah", description: "سبحان الله", count: 0, audio: "8"),
                   DhikrModel(img: UIImage(systemName: "2.circle.fill")!, name: "La illaha illallah Muhammadur Rasulullah", description: "لا إله إلا الله محمد رسول الله", count: 0, audio: "4"),
                   DhikrModel(img: UIImage(systemName: "3.circle.fill")!, name: "Laa ilaaha ill-Allaah wahdahu laa shareeka lah, lahu’l-mulk wa lahu’l-hamd wa huwa ‘ala kulli shay’in qadeer", description: "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يحي و يميت وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", count: 0, audio: "7"),
                   DhikrModel(img: UIImage(systemName: "4.circle.fill")!, name: "Subhaan Allaah wa bi hamdihi Subhaan Allaah il-‘Azeem ", description: "سُبْحَانَ اللَّهِ الْعَظِيمِ سُبْحَانَ اللَّهِ وَبِحَمْدِه ‏", count: 0, audio: "1"),
                   DhikrModel(img: UIImage(systemName: "5.circle.fill")!, name: "Subhaan Allaah, wa’l-hamdu Lillah, wa laa ilaah ill-Allaah, wa Allaahu akbar", description: ",سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلاَ إِلَهَ إِلاَّ اللَّهُ وَاللَّهُ أَكْبَرُ", count: 0, audio: "10"),
                   DhikrModel(img: UIImage(systemName: "6.circle.fill")!, name: "Laa hawla wa laa quwwata illa Billaah", description: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", count: 0, audio: "3"),
                   DhikrModel(img: UIImage(systemName: "7.circle.fill")!, name: "SubhanAlaah,Alhumdulillah,Allahuakbar", description: "سُبْحَانَ اللَّهِ الْحَمْدُ لِلَّهِ اللَّهُ أَكْبَر", count: 0, audio: "2"),
                   DhikrModel(img: UIImage(systemName: "8.circle.fill")!, name: "Astaghfir-Allaah", description: "أَسْتَغْفِرُ اللّٰهَ", count: 0, audio: "9" ),
                   DhikrModel(img: UIImage(systemName: "9.circle.fill")!, name: "Hasbunallahu Wa Ni'mal Wakeel", description: "حَسْبُنَا اللَّهُ وَ نِعْمَ الْوَ كِيلُ", count: 0, audio: "6"),
                   DhikrModel(img: UIImage(systemName: "10.circle.fill")!, name: "Allahumma Salli ‘ala Muhammadin wa ‘ala aali Muhammad", description: "ٱللَّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ", count: 0, audio: "5")]
    
    @IBOutlet var tblView: UITableView!
    let vc = DetailsDhikrViewController()
    var indexCell = 0
    var total = 0
    
    @objc func dismisss(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "main") else{return}
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(self.dismisss))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        navigationItem.title = "Personal Dhikres"
    }
}

extension DhikrTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension DhikrTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DhikrCellsTableViewCell
        let object = objects[indexPath.row]
        cell.imageNumber.image = object.img
        cell.dhikres.text = object.name
        cell.meaningOfDhikr.text = object.description
        cell.totalLabel.text = String(object.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailsDhikrViewController else {fatalError("Unable page")}
        let object = objects[indexPath.row]
        vc.audioDhikr = object.audio
        vc.arabDhikr = object.description
        vc.engDhikr = object.name
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension DhikrTableViewController: DetailsDhikrViewControllerDelegate {
    func changeTheCounter(info: String) {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell") as! DhikrCellsTableViewCell
        cell.totalLabel.text! = info
        print(cell.totalLabel.text!)
    }
}

