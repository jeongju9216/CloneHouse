//
//  CircleIconCollectionViewCell.swift
//  CloneHouse
//
//  Created by 유정주 on 2023/06/08.
//

import UIKit

class CircleIconCollectionViewCell: UICollectionViewCell {

    //MARK: - Views
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    private var isNew = false
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI(height: frame.height)
    }

    private func setupUI(height: CGFloat) {
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = height / 2
        backView.layer.borderColor = isNew ? UIColor(named: "MainColor")?.cgColor : UIColor.gray.cgColor
        backView.layer.borderWidth = 3
        
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = (height - 2) / 2
        iconImageView.layer.borderColor = UIColor.systemBackground.cgColor
        iconImageView.layer.borderWidth = 3
    }
    
    private func resetUI() {
        isNew = false
        iconImageView.image = nil
    }
    
    //MARK: - Methods
    func configuration(with app: CloneApp, isNew: Bool) {
        resetUI()
        
        iconImageView.image = UIImage(named: app.iconName)
        self.isNew = isNew
    }
}
