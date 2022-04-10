//
//  HomeViewController.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 07/04/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    let context = CoreDataStack().context

    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    
    @IBAction func HelloButtonPressed(_ sender: UIButton) {
        helloLbl.text = "Hello World"
        sampleTest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Hello World from Terminal")
        sampleTest()
    }
    
    func sampleTest() {
        do {
//            let haha = Session()
//            haha.start = Date()
//            haha.end = Date()
//            haha.targetEnd = Date()
//            try SessionRepository.shared.save(haha)
            let sample2 = try SessionRepository.shared.getAll(predicate: nil)
            print(sample2.count)
            resultLbl.text = String(sample2.count)
            let willModuf = sample2.first
            print(willModuf?.id)
            print(willModuf?.end)
            willModuf?.end = Date()
            let moduf = try SessionRepository.shared.update(willModuf!)
        } catch {
        }
    }

}

