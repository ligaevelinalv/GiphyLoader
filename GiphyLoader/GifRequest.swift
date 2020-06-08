//
//  File.swift
//  GiphyLoader
//
//  Created by liga.evelina.liepina on 20/05/2020.
//  Copyright © 2020 liga.evelina.liepina. All rights reserved.
//

import Foundation

struct Gif {
    var gifURL: URL
    var loopingImageURL: URL
    var displayableGifURL: URL
    var lowerQualGifURL: URL
    var gifTitle: String

}

struct GifRequest {
    let resourceURL : URL?
    let API_KEY = "lR2WGQhGym2FJN3Qnm9CA5jsu9OyUyq3"

    init(gifQuery:String) {
    let gifQueryFixed = gifQuery.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil).lowercased()

        let resourceString = "http://api.giphy.com/v1/gifs/search?q=\(gifQueryFixed)&api_key=\(API_KEY)&limit=30"
         self.resourceURL = URL(string: resourceString)
    }

    func getGifs (completion: @escaping([Gif]) -> Void) {
        guard let getURL = resourceURL else { return }

        let dataTask = URLSession.shared.dataTask(with: getURL, completionHandler: { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let data = data else { return }
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                guard
                    let json = jsonData as? [String: Any],
                    let gifData = json["data"] as? [[String: Any]]
                    else { return }
                var gifArr = [Gif]()
                gifData.forEach {
                    guard
                        let urlString = $0["url"] as? String,
                        let title = $0["title"] as? String,
                        let images = $0["images"] as? [String: Any],
                        let looping = images["looping"] as? [String: Any],
                        let loopingMP4UrlString = looping["mp4"] as? String,
                        let original = images["original"] as? [String: Any],
                        let displayableGifURL = original["url"] as? String,
                        let fixedHeightDownsampled = images["fixed_height_downsampled"] as? [String: Any],
                        let lowerQualityGifURL = fixedHeightDownsampled["url"] as? String
                    else { return }

                    //unwrapping optionals
                    guard let finGifUrl = URL(string: urlString) else {return}
                    guard let finLoopUrl = URL(string: loopingMP4UrlString) else {return}
                    guard let findDisplUrl = URL(string: displayableGifURL) else {return}
                    guard let finLowDisplUrl = URL(string: lowerQualityGifURL) else {return}
                    let finTitle = title

                    let gifInfo = Gif(gifURL: finGifUrl, loopingImageURL: finLoopUrl, displayableGifURL: findDisplUrl, lowerQualGifURL: finLowDisplUrl, gifTitle: finTitle)
                    gifArr.append(gifInfo)
                }
                completion(gifArr)
            }
        })
        dataTask.resume()
    }
}
