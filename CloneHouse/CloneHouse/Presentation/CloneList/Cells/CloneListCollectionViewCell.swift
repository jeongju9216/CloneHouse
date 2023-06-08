//
//  CloneListCollectionViewCell.swift
//  CloneHouse
//
//  Created by 유정주 on 2023/06/08.
//

import UIKit

final class CloneListCollectionViewCell: UICollectionViewCell {

    //MARK: - Views
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        backView.layer.masksToBounds = false
        backView.layer.cornerRadius = 20
        
        backView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        backView.layer.borderWidth = 2
        
        backView.layer.shadowColor = UIColor.gray.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowRadius = 2
        backView.layer.shadowOffset = .init(width: 0, height: 2)
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 20
        iconImageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        iconImageView.layer.borderWidth = 2
    }
    
    private func resetUI() {
        iconImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
    }

    //MARK: - Methods
    func configuration(with app: CloneApp) {
        resetUI()
        
        iconImageView.image = UIImage(named: app.iconName)
        titleLabel.text = app.title
        descriptionLabel.text = app.description
    }
}
