//
//  CharacterListViewController.swift
//  Marvel Characters
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CharacterListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!

    let disposeBag = DisposeBag()

    let dataSource = BehaviorRelay<[MarvelCharacter]>(value: [])

    /// Value of current page
    var currentPage = BehaviorRelay<Int>(value: 0)

    var chs: NetworkService?
    var rx_characters: Driver<Result<[MarvelCharacter], RequestError>>?

    let errorValidation = { (result: Result<[MarvelCharacter], RequestError>) -> Driver<[MarvelCharacter]> in
        switch result {
        case .success(let character):
            return Driver.just(character)
        case .failure:
            return Driver.empty()
        }
    }
    var loadingMore = false {
        didSet {
            footerView.isHidden = !loadingMore
        }
    }
    var readyToLoadMore = true

    var currentPageObservable: Observable<Int>!

    override func viewDidLoad() {
        super.viewDidLoad()

        currentPageObservable = currentPage
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 >= 0 }

        createCharacterService()
        rx_characters = chs?.getData(Routes.listCharacters)
        appendSubscribers()
        setupPagination()

        tableView.accessibilityIdentifier = "MainCharacterList"
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.black
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil

        navigationController?.setNavigationBarHidden(false, animated: false)

        navigationController?.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let nav = navigationController?.delegate as? CharacterListViewController, nav == self {
            navigationController?.delegate = nil
        }
    }

    func createCharacterService() {
        chs = NetworkService(pageObservable: currentPageObservable)
    }

    func setupPagination() {

        tableView.rx.contentOffset
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            //  .throttle(0.05, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { [weak self] (offset)  in
                guard let `self` = self else {return false }

                guard
                    self.readyToLoadMore &&
                        offset.y > UIScreen.main.bounds.height
                    else {return false}
                self.readyToLoadMore = false
                return true
            }
            .observeOn(MainScheduler.instance)
            .bind { [weak self] (offset) in
                guard let `self` = self else { return }

                print("offset = \(offset)")
                let bounds = self.tableView.bounds
                let size = self.tableView.contentSize
                let inset = self.tableView.contentInset
                let y = offset.y + bounds.size.height - inset.bottom
                let h = size.height
                let reload_distance: CGFloat = UIScreen.main.bounds.height * 2
                if y > (h - reload_distance) {
                    self.loadingMore = true

                    self.currentPage.accept(self.currentPage.value + 1)
                    print("load page = \(self.currentPage.value)")
                } else {
                    self.readyToLoadMore = true
                }
            }
            .disposed(by: disposeBag)
    }

    func appendSubscribers() {
        dataSource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: "CharacterCell", cellType: CharacterCell.self)) { (_, character, cell) in

                if let nameLabel = cell.nameLabel as? UIButton {
                    nameLabel.setTitle(character.name, for: UIControl.State.normal)
                } else if let nameLabel = cell.nameLabel as? UILabel {
                    nameLabel.text = character.name
                }

                cell.nameLabel.sizeToFit()
                cell.bannerImage.image = nil

                cell.setEditing(false, animated: false)

                guard let url = character.thumbnail?.url(), let nsurl = NSURL(string: url), let modified = character.modified else { return }
                ImageSource.downloadImageAndSetIn(cell.bannerImage, imageURL: nsurl as URL, withUniqueKey: modified)
            }
            .disposed(by: disposeBag)

        rx_characters?
            .flatMapLatest(errorValidation)
            .drive(onNext: { (newPage) in
                var dataSource = self.dataSource.value
                dataSource.append(contentsOf: newPage)
                self.dataSource.accept(dataSource)

                if newPage.count < APIHandler.itemsPerPage {
                    self.loadingMore = false
                }
                self.readyToLoadMore = true
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let characterDetails = segue.destination as? CharacterProviderDelegate {

            guard
                let indexPath = tableView.indexPathForSelectedRow,
                let cell = tableView.cellForRow(at: indexPath) as? CharacterCell
                else { return }

            let character = dataSource.value[indexPath.row]

            characterDetails.character = character
            characterDetails.characterImage = cell.bannerImage?.image
        }
    }
}

extension CharacterListViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self == fromVC && toVC is BlurredImageContainerViewController {
            return RepositionImageZoomingTransition()
        }
        return nil
    }
}

extension CharacterListViewController: RepositionImageZoomingTransitionProtocol {

    func getImageView() -> UIImageView? {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? CharacterCell
            else { return nil }
        return cell.bannerImage
    }

    func doBeforeTransition() {

        getCell()?.isHidden = true
        navigationController?.navigationBar.alpha = 0

    }

    func getEnclosingView() -> UIView {
        return getCell()!
    }

    fileprivate func getCell() -> UITableViewCell? {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? CharacterCell
            else { return nil}
        return cell
    }

    func doAfterTransition() {
        view.alpha = 1
        getCell()?.isHidden = false
        navigationController?.navigationBar.alpha = 1

    }

    func doWhileTransitioningStepOne() {
        view.alpha = 0

    }
    func doWhileTransitioningStepTwo() {

    }
    func doWhileTransitioningStepThree() {
        navigationController?.navigationBar.alpha = 1
    }

    func getViewOfController() -> UIView {
        return self.view
    }
    func getViewController() -> UIViewController {
        return self
    }

}
