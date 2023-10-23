//
//  HeroesViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    func loadData()
    var heroesCount: Int { get }
    func heroBy(index: Int) -> Hero?
}

//var viewState

enum HeroesViewState {
    case updateData
}

class HeroesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        viewModel?.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ocultar el botón de retroceso en la barra de navegación
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func initViews() {
        tableView.register(UINib(nibName: HeroeCell.identifier, bundle: nil) ,
                           forCellReuseIdentifier: HeroeCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .updateData:
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: Delegate and Data Source
extension HeroesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        HeroeCell.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroeCell.identifier,
                                                       for: indexPath) as? HeroeCell else {
            return UITableViewCell()
        }
        
        let hero = viewModel?.heroBy(index: indexPath.row)
        cell.updateViewCell(name: hero?.name ,
                            description: hero?.description,
                            photo: hero?.photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
