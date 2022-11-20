//
//  DetailViewController.swift
//  CovidCombineMVVM
//
//  Created by Marco Alonso Rodriguez on 20/11/22.
//

import UIKit

class DetailViewController: UIViewController {

    var infoSong: SearchResult?
    
    @IBOutlet weak var infoSongTextView: UITextView!
    @IBOutlet weak var albumImage: UIImageView!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getImageWithCompletion(urlString: infoSong?.artworkUrl60 ?? "") { [weak self] image, error in
            DispatchQueue.main.async {
                self?.albumImage.image = image
            }
        }
        
        if infoSong != nil {
            self.infoSongTextView.text = infoSongTextView.text + "\n \(String(describing: infoSong!.trackName ?? ""))"
            self.infoSongTextView.text = infoSongTextView.text + "\n \(String(describing: infoSong!.collectionName ?? ""))"
            self.infoSongTextView.text = infoSongTextView.text + "\n \(String(describing: infoSong!.trackPrice ?? 0.0))"
            self.infoSongTextView.text = infoSongTextView.text + "\n \(String(describing: infoSong!.trackId ?? 0))"
            self.infoSongTextView.text = infoSongTextView.text + "\n \(String(describing: infoSong!.currency ?? ""))"
        }
        
       
        
    }
    

}
