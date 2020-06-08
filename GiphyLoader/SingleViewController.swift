//
//  SingleViewController.swift
//  GiphyLoader
//
//  Created by liga.evelina.liepina on 20/05/2020.
//  Copyright © 2020 liga.evelina.liepina. All rights reserved.
//

import Kingfisher

class SingleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showGif(showGifURL: displayableURL)
        fixTitle()
        titleLabel.text = gifTitle.capitalizingFirstLetter()
        clipUrlButton.layer.cornerRadius = 5
        navigationController?.navigationBar.barTintColor = UIColor.black


    }
    
    var displayableURL = ""
    var shareableURL = ""
    var gifTitle = ""
    
    @IBOutlet weak var clipUrlButton: UIButton!

    @IBOutlet weak var singleViewImage: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func onClickButton(_ sender: Any) {
        UIPasteboard.general.string = shareableURL
    }

    func showGif(showGifURL: String) {
        singleViewImage.kf.indicatorType = .activity
        self.singleViewImage.kf.setImage(with: URL(string:showGifURL), options: [.transition(.fade(0.2))])

    }

    func fixTitle() {
        if !gifTitle.isEmpty && gifTitle.count > 4 {
            let index = gifTitle.index(gifTitle.endIndex, offsetBy: -4)
            let substr = gifTitle[index...]

            if substr == " gif" || substr == " GIF" {
                let range = gifTitle.index(gifTitle.endIndex, offsetBy: -4)..<gifTitle.endIndex
                gifTitle.removeSubrange(range)
            }
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

