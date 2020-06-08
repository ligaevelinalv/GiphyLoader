//
//  ViewController.swift
//  GiphyLoader
//
//  Created by liga.evelina.liepina on 20/05/2020.
//  Copyright © 2020 liga.evelina.liepina. All rights reserved.
//

import Kingfisher


class MainViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    var displayableGifUrl = ""
    var shareableGifUrl = ""
    var gifTitle = ""
    
    let throttler = Throttler(minimumDelay: 0.7)

    var listOfGifs = [Gif]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self

        navigationController?.navigationBar.barTintColor = UIColor.black

    }

    @IBAction func textFieldChanged(_ sender: UITextField) {

        throttler.throttle {
            let cache = ImageCache.default
            cache.clearMemoryCache()
            cache.clearDiskCache { print("Memory cleanup done.") }

            if let searchItem = sender.text {
                if searchItem.isEmpty != true {
                    DispatchQueue.global().async { [weak self] in
                        let gifData = GifRequest(gifQuery: searchItem)
                        gifData.getGifs { result in
                            self?.listOfGifs = result
                        }
                    }
                }
            }
        }


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayableGifUrl = listOfGifs[indexPath.row].displayableGifURL.absoluteString
        shareableGifUrl = listOfGifs[indexPath.row].gifURL.absoluteString
        gifTitle = listOfGifs[indexPath.row].gifTitle
        showSingleView()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let singleViewController = segue.destination as? SingleViewController
        singleViewController?.displayableURL = displayableGifUrl
        singleViewController?.shareableURL = shareableGifUrl
        singleViewController?.gifTitle = gifTitle
    }

    func showSingleView() {
        performSegue(withIdentifier: "ShowFullGif", sender: self)
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .darkContent
//    }

//perform and prepare segue


//    func warning() {
//        let alert = UIAlertController(title: "Uh oh! Something happened!", message: "Please redo your search", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Ok", style: .cancel, handler: { action in
//        })
//
//        alert.addAction(action)
//
//        self.present(alert, animated: true)
//    }

}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfGifs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath)
        (cell as? CollectionViewCell)?.getURL(gifURL: listOfGifs[indexPath.row].lowerQualGifURL)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize.init(
        width: collectionView.bounds.width/3 - 8,
        height: collectionView.bounds.width/3 - 8
    )
    }
}




