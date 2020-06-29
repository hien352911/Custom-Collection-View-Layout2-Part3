//
//  MasterViewController.swift
//  Character Collector
/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 

import UIKit
import AVFoundation

class MasterViewController: UICollectionViewController {
  
  let charactersData = Characters.loadCharacters()
      
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController!.isToolbarHidden = true
    
    let layout = collectionViewLayout as! MosaicViewLayout
    layout.numberOfColumns = 2
    layout.delegate = self
    layout.cellPadding = 5
    
    collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
    
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "MasterToDetail" {
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.character = sender as? Characters
    }
  }
    
    @IBAction func carouseLayoutButtonAction(_ sender: UIButton) {
        let layout = CarouselViewLayout()
        layout.delegate = self
        layout.numberOfColumns = 1
        layout.cellPadding = -20
        
        collectionView!.contentInset = UIEdgeInsets(top: 5, left: 100, bottom: 10, right: 100)
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }
    
    @IBAction func mosaicLayoutButtonAction(_ sender: UIButton) {
        let layout = MosaicViewLayout()
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 5
        
        collectionView!.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
    }
}


// MARK: UICollectionViewDataSource
extension MasterViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return charactersData.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! RoundedCharacterCell
    
    // Configure the cell
    let character = charactersData[indexPath.item]
    cell.character = character 
    
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension MasterViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let character = charactersData[indexPath.item]
      performSegue(withIdentifier: "MasterToDetail", sender: character)
  }
}

extension MasterViewController: MosaicViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let character = charactersData[indexPath.row]
        let image = UIImage(named: character.name)
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: image!.size, insideRect: boundingRect)
        
        return rect.height
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let character = charactersData[indexPath.item]
        let descriptionHeight = heightForText(character.description, width: width - 24)
        let height = 4 + 17 + 4 + descriptionHeight + 12
        return height
    }
    
    func heightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 10)
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: [NSAttributedString.Key.font : font],
                                                       context: nil)
        return ceil(rect.height)
    }
}





