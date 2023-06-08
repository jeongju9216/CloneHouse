//
//  CloneListViewController.swift
//  CloneZip
//
//  Created by 유정주 on 2023/05/22.
//

import UIKit

final class CloneListViewController: UIViewController {
    enum Sections: Int, CaseIterable {
        case news, app
    }
    
    //MARK: - Views
    @IBOutlet weak var collectionView: UICollectionView!
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Sections, CloneApp>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, CloneApp>

    //MARK: - Properties
    private lazy var dataSource: DataSource = setupDataSource()
    private var snapshot: SnapShot = SnapShot()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
        initTestData()
        
    }
    
    //MARK: - Setup
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = createCollectionViewLayout()
        
        registerCollectionViewCell()
    }
    
    private func initTestData() {
        //테스트 데이터
        updateCloneAppList(data: [CloneApp(title: "Jetflix", description: "넷플릭스 클론 코딩 앱", version: "v1.0.0", releaseDate: "2023.06.08"),
                                  CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                                  CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                                  CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                                  CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test")])
    }
}

//MARK: - Setup CollectionView
extension CloneListViewController {
    private func updateCloneAppList(data: [CloneApp]) {
        snapshot = SnapShot()
        snapshot.appendSections([.app])
        
        snapshot.appendItems(data, toSection: .app)
        
        dataSource.apply(snapshot, animatingDifferences:  false)
    }
    
    private func updateCircleIconList(data: [CloneApp]) {
        if snapshot.indexOfSection(.news) == nil {
            snapshot.appendSections([.news])
        }
        
        snapshot.appendItems(data, toSection: .news)
        
        dataSource.apply(snapshot, animatingDifferences:  false)
    }
    
    private func registerCollectionViewCell() {
        collectionView.register(DefaultCollectionViewCell.cellClassWithNib, forCellWithReuseIdentifier: DefaultCollectionViewCell.idenfier)
        collectionView.register(CloneListCollectionViewCell.cellClassWithNib, forCellWithReuseIdentifier: CloneListCollectionViewCell.idenfier)
        collectionView.register(CircleIconCollectionViewCell.cellClassWithNib, forCellWithReuseIdentifier: CircleIconCollectionViewCell.idenfier)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let defaultSection = NSCollectionLayoutSection.list(using: .init(appearance: .plain), layoutEnvironment: layoutEnvironment)
            guard let self = self else { return defaultSection }
            
            var sectionIndex = sectionIndex
            if self.snapshot.numberOfSections == 1 {
                sectionIndex += 1
            }
            
            switch Sections(rawValue: sectionIndex) {
            case .news:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                                      heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                group.edgeSpacing = .init(leading: .fixed(10), top: .none, trailing: .fixed(10), bottom: .none)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                return section
                
            case .app:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(140))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            default: return defaultSection
            }
        }
        
        return layout
    }
    
    private func setupDataSource() -> DataSource {
        let cellProvider = { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, product: CloneApp) -> UICollectionViewCell? in
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.idenfier, for: indexPath)
            guard let self = self else { return defaultCell }
            
            var sectionIndex = indexPath.section
            if self.snapshot.numberOfSections == 1 {
                sectionIndex += 1
            }

            switch Sections(rawValue: sectionIndex) {
            case .news:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleIconCollectionViewCell.idenfier, for: indexPath) as? CircleIconCollectionViewCell else {
                    return defaultCell
                }
                
                if indexPath.row % 2 == 0 {
                    cell.configuration(with: product, isNew: true)
                } else {
                    cell.configuration(with: product, isNew: false)
                }
                
                
                return cell
            case .app:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CloneListCollectionViewCell.idenfier, for: indexPath) as? CloneListCollectionViewCell else {
                    return defaultCell
                }
                
                cell.configuration(with: product)
                
                return cell
                
            default: return defaultCell
            }
        }
        
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        return dataSource
    }
}
