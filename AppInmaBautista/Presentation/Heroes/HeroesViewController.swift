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
    func heroBy(index: Int) -> HeroDAO?
    func logOut()
    var loginViewModel: LoginViewControllerDelegate { get }
}

//var viewState

enum HeroesViewState {
    case updateData
    case navigateToLogin
    case navigateToDetail
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "HEROES_TO_LOGIN",
              let loginViewController = segue.destination as? LoginViewController else {return}
        loginViewController.viewModel = viewModel?.loginViewModel
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
                case .navigateToLogin:
                    self?.performSegue(withIdentifier: "HEROES_TO_LOGIN", sender: nil)
                case .navigateToDetail:
                    break
                }
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        viewModel?.logOut()
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
        cell.updateViewCell(id: hero?.id,
                            name: hero?.name,
                            description: hero?.heroDescription,
                            photo: hero?.photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
