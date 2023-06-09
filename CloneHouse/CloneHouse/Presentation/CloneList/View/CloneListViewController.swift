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
    private var searchController: UISearchController = .init()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Sections, CloneApp>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Sections, CloneApp>

    //MARK: - Properties
    private lazy var dataSource: DataSource = setupDataSource()
    private var snapshot: SnapShot = SnapShot()
    
    private var isShowNewsSection = false
    private var isSearching = false
    
    private let testAppData = [CloneApp(title: "Jetflix", description: "넷플릭스 클론 코딩 앱", version: "v1.0.0", releaseDate: "2023.06.08"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test")]
    private let testNewsData = [CloneApp(title: "Jetflix", description: "넷플릭스 클론 코딩 앱", version: "v1.0.0", releaseDate: "2023.06.08"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test"),
                            CloneApp(title: "Jetflix", description: "Test", version: "Test", releaseDate: "Test")]
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
        initTestData()
        
    }
    
    //MARK: - Setup
    private func setupUI() {
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        //configureWithTransparentBackground는 스크롤할 때 뒤가 안 가려져서 컬러로 지정함
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.showsVerticalScrollIndicator = false
        
        registerCollectionViewCell()
    }
    
    private func initTestData() {
        //테스트 데이터
        updateCloneAppList(data: testAppData)
        
        updateCircleIconList(data: testNewsData)
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "키워드를 입력하세요."
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

//MARK: - Setup CollectionView
extension CloneListViewController {
    private func updateCloneAppList(data: [CloneApp], animate: Bool = false) {
        snapshot = SnapShot()
        snapshot.appendSections([.app])
        
        snapshot.appendItems(data, toSection: .app)
        
        dataSource.apply(snapshot, animatingDifferences:  false)
    }
    
    private func updateCircleIconList(data: [CloneApp], animate: Bool = false) {
        if snapshot.indexOfSection(.news) == nil {
            snapshot.insertSections([.news], beforeSection: .app)
        }
        
        snapshot.appendItems(data, toSection: .news)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
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
            
            let section = self.snapshot.sectionIdentifiers[sectionIndex]
            switch section {
            case .news:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                                      heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                group.edgeSpacing = .init(leading: .fixed(10), top: .none, trailing: .fixed(10), bottom: .none)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
                
                return section
                
            case .app:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(140))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }
        
        return layout
    }
    
    private func setupDataSource() -> DataSource {
        let cellProvider = { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, product: CloneApp) -> UICollectionViewCell? in
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCollectionViewCell.idenfier, for: indexPath)
            guard let self = self else { return defaultCell }
            
            let section = self.snapshot.sectionIdentifiers[indexPath.section]
            switch section {
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
            }
        }
        
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        return dataSource
    }
}

//MARK: - UISearchBarDelegate
extension CloneListViewController: UISearchBarDelegate {
    //텍스트 변경
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(#function): \(searchText)")
    }
    
    //키보드 입력 시작
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
        isSearching = true
        
        //키보드 패딩 테스트 코드
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 300, right: 0)
        
        //View 사라지는거 테스트 코드
        snapshot.deleteSections([.news])
        dataSource.apply(snapshot)
    }
    
    //키보드 입력 끝
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(#function)
        isSearching = false
        
        //키보드 패딩 테스트 코드
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        //View 사라지는거 테스트 코드
        updateCircleIconList(data: testNewsData, animate: true)
    }
    
    //검색 버튼
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    //취소 버튼
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
}

//MARK: - UICollectionViewDelegate
extension CloneListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = collectionView.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        if !isSearching {
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        }
    }
}
