//
//  FailViewController.swift
//  Biinge
//
//  Created by Nathania Joyce on 11/04/22.
//

import UIKit

class FailViewController: UIViewController {

    //let
    let texts = ["Binge-watching for hours is one of the activities of a sedentary, which can increases the risk of death 20%-30% higher than people who have sufficient physical activity. Therefore it needs to be limited.", "If you’re watching a series, end your session in the middle of an episode. It usually concludes the last episode’s conflicts and cliffhangers, so you don’t crave more.", "Binge-watch with friends! They won’t want you to watch it without them, holding your binge-watching craving at bay until your next get-together."]
    
    //var
    var a1 : UIImage!
    var a2 : UIImage!
    var a3 : UIImage!
    var a4 : UIImage!
    var a5 : UIImage!
    var a6 : UIImage!
    var a7 : UIImage!
    var a8 : UIImage!
    var a9 : UIImage!
    var a10 : UIImage!
    var a11 : UIImage!
    var a12 : UIImage!
    var a13 : UIImage!
    var a14 : UIImage!
    var a15 : UIImage!
    var a16 : UIImage!
    var a17 : UIImage!
    var a18 : UIImage!
    var a19 : UIImage!
    var a20 : UIImage!
    var a21 : UIImage!
    var a22 : UIImage!
    var a23 : UIImage!
    var a24 : UIImage!
    var a25 : UIImage!
    var a26 : UIImage!
    var a27 : UIImage!
    var a28 : UIImage!
    var a29 : UIImage!
    var a30 : UIImage!
    var a31 : UIImage!
    var a32 : UIImage!
    var a33 : UIImage!
    var a34 : UIImage!
    var a35 : UIImage!
    var a36 : UIImage!
    var a37 : UIImage!
    var a38 : UIImage!
    var a39 : UIImage!
    var a40 : UIImage!
    var a41 : UIImage!
    var a42 : UIImage!
    var a43 : UIImage!
    var a44 : UIImage!
    var a45 : UIImage!
    var a46 : UIImage!
    var a47 : UIImage!
    var a48 : UIImage!
    var a49 : UIImage!
    var a50 : UIImage!
    var a51 : UIImage!
    var a52 : UIImage!
    var a53 : UIImage!
    var a54 : UIImage!
    var a55 : UIImage!
    
    //also var buat images
    var images: [UIImage]!
    
    //buat animated images
    var animatedImage: UIImage!
    
    
    //buat IBOutlet
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        a1 = UIImage(named: "o1.png")
        a2 = UIImage(named: "o2.png")
        a3 = UIImage(named: "o3.png")
        a4 = UIImage(named: "o4.png")
        a5 = UIImage(named: "o5.png")
        a6 = UIImage(named: "o6.png")
        a7 = UIImage(named: "o7.png")
        a8 = UIImage(named: "o8.png")
        a9 = UIImage(named: "o9.png")
        a10 = UIImage(named: "o10.png")
        a11 = UIImage(named: "o11.png")
        a12 = UIImage(named: "o12.png")
        a13 = UIImage(named: "o13.png")
        a14 = UIImage(named: "o14.png")
        a15 = UIImage(named: "o15.png")
        a16 = UIImage(named: "o16.png")
        a17 = UIImage(named: "o17.png")
        a18 = UIImage(named: "o18.png")
        a19 = UIImage(named: "o19.png")
        a20 = UIImage(named: "o20.png")
        a21 = UIImage(named: "o21.png")
        a22 = UIImage(named: "o22.png")
        a23 = UIImage(named: "o23.png")
        a24 = UIImage(named: "o24.png")
        a25 = UIImage(named: "o25.png")
        a26 = UIImage(named: "o26.png")
        a27 = UIImage(named: "o27.png")
        a28 = UIImage(named: "o28.png")
        a29 = UIImage(named: "o29.png")
        a30 = UIImage(named: "o30.png")
        a31 = UIImage(named: "o31.png")
        a32 = UIImage(named: "o32.png")
        a33 = UIImage(named: "o33.png")
        a34 = UIImage(named: "o34.png")
        a35 = UIImage(named: "o35.png")
        a36 = UIImage(named: "o36.png")
        a37 = UIImage(named: "o37.png")
        a38 = UIImage(named: "o38.png")
        a39 = UIImage(named: "o39.png")
        a40 = UIImage(named: "o40.png")
        a41 = UIImage(named: "o41.png")
        a42 = UIImage(named: "o42.png")
        a43 = UIImage(named: "o43.png")
        a44 = UIImage(named: "o44.png")
        a45 = UIImage(named: "o45.png")
        a46 = UIImage(named: "o46.png")
        a47 = UIImage(named: "o47.png")
        a48 = UIImage(named: "o48.png")
        a49 = UIImage(named: "049.png")
        a50 = UIImage(named: "o50.png")
        a51 = UIImage(named: "o51.png")
        a52 = UIImage(named: "o52.png")
        a53 = UIImage(named: "o53.png")
        a54 = UIImage(named: "o54.png")
        a55 = UIImage(named: "o55.png")

        
        images = [a1, a2, a3, a4, a5, a6, a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31,a32,a33,a34,a35,a36,a37,a38,a39,a40,a41,a42,a43,a44,a45,a46,a47,a48,a49,a50,a51,a52,a53,a54,a55]
        
        animatedImage = UIImage.animatedImage(with: images, duration: 3.0)
        
        viewImage.image = animatedImage
        // Do any additional setup after loading the view.
        textView.text = texts.randomElement()
    }
}
