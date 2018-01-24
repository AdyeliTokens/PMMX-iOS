//
//  CustomCell.swift
//  pmmx
//
//  Created by ISPMMX on 12/18/17.
//  Copyright © 2017 com.pmi. All rights reserved.
//

import UIKit

protocol CustomCellDelegate
{
    func directionPan(direccion: CGFloat)
}

class CustomCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var cellLabel: UILabel!
    var imgView: UIImageView!
    var pan: UIPanGestureRecognizer!
    var saveLabel: UILabel!
    var deleteLabel: UILabel!
    var delegate : CollectionViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        cellLabel = UILabel()
        cellLabel.textColor = UIColor(displayP3Red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.numberOfLines = 3
        self.contentView.addSubview(cellLabel)
        cellLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        cellLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        cellLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        cellLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        saveLabel = UILabel()
        saveLabel.text = "YES"
        saveLabel.textColor = UIColor.white
        saveLabel.backgroundColor = UIColor.green
        saveLabel.tag = 1
        self.insertSubview(saveLabel, belowSubview: self.contentView)
        
        deleteLabel = UILabel()
        deleteLabel.text = "NO"
        deleteLabel.textColor = UIColor.white
        deleteLabel.backgroundColor = UIColor.red
        deleteLabel.tag = 2
        self.insertSubview(deleteLabel, belowSubview: self.contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    override func prepareForReuse() {
        self.contentView.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizerState.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            self.saveLabel.frame = CGRect(x: p.x - saveLabel.frame.size.width-10, y: 0, width: 100, height: height)
            
            self.deleteLabel.frame = CGRect(x: p.x + width + deleteLabel.frame.size.width, y: 0, width: 100, height: height)
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        
        switch pan.state {
        case .began:
            break
        case .changed:
            self.setNeedsLayout()
            break
        case .ended:
            let velocity = pan.velocity(in: self).x
            if abs(velocity) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
                self.delegate?.directionPan(direccion: velocity)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
            break
            
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
}
