//
//  ShareProfileViewController.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 12/04/22.
//

import UIKit

class ShareProfileViewController: UIViewController {
    
    @IBOutlet weak var previewShareImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Social Share
    
    var storyImg = UIImage()
    var profileImg: UIImage = UIImage(data: UserProfile.shared.pic as Data) ?? UIImage(named: "PersonPlaceholder")!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let bundle = Bundle(for: ShareViewContent.self)
        let contentView = UINib(nibName: "ShareViewContent", bundle: bundle)
        let contentViewShow = contentView.instantiate(withOwner: self, options: nil)[0] as! ShareViewContent
        
        contentViewShow.userProfileImg.image = self.profileImg.circleMasked
        
        // TODO: Connect this to real data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        
        let monthTotalWatchtime = SessionHelper.shared.getLifetimeTotalTimeInSecond()
        let (h, m, _) = (monthTotalWatchtime / 3600, (monthTotalWatchtime % 3600) / 60, (monthTotalWatchtime % 3600) % 60)
        
        let totalSession = UserProfile.shared.exceed + UserProfile.shared.accomplish
        
        contentViewShow.monthYearLbl.text = dateFormatter.string(from: Date())
        contentViewShow.totalWatchTimeLbl.text = "\(h) h \(m) m"
        contentViewShow.sessionSuccessLbl.text = String(UserProfile.shared.accomplish)
        contentViewShow.sessionTotalLbl.text = String(totalSession)
        contentViewShow.longestStreakLbl.text = String(UserProfile.shared.streak)
        contentViewShow.accuracyRateLbl.text = totalSession > 0 ? String(format: "%.1f", Double(UserProfile.shared.accomplish) / Double(totalSession) * 100.0) + " %" : "- %"
        
        self.storyImg = contentViewShow.asImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        previewShareImage.image = self.storyImg
        previewShareImage.layer.borderWidth = 3
        previewShareImage.layer.borderColor = UIColor(named: "GrayText")?.cgColor
        previewShareImage.layer.cornerRadius = 15
    }
    
    @IBAction func shareToIGStory() {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let imageData = self.storyImg.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.backgroundImage": imageData,
                    // "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                if #available(iOS 10, *) {
                    let pasteboardOptions = [
                        UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                    ]
                    UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                    UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                }
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Sorry the application is not installed")
            }
        }
    }
    
    @IBAction func shareOrDownload() {
        self.normalShare(self.storyImg)
    }
    
    private func normalShare(_ image: UIImage) {
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ .markupAsPDF, .addToReadingList, .print, .assignToContact ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

}
