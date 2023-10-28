//
//  HeroesViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    var loginViewModel: LoginViewControllerDelegate { get }
    var mapViewModel: MapViewControllerDelegate { get }
    func onViewAppear()
    func heroBy(index: Int) -> HeroDAO?
    func logOut()
    
}

//var viewState

enum HeroesViewState {
    case updatedData
    case navigateToLogin
    case navigateToDetail
    case navigateToMap
}

class HeroesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        viewModel?.onViewAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ocultar el botón de retroceso en la barra de navegación
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case  "HEROES_TO_LOGIN":
                guard let loginViewController = segue.destination as? LoginViewController else {return}
                loginViewController.viewModel = viewModel?.loginViewModel
            case "HEROES_TO_MAP":
                guard let mapViewController = segue.destination as? MapViewController else {return}
                mapViewController.viewModel = viewModel?.mapViewModel
            case "HEROES_TO_DETAIL":
                break
            default:
                break
        }
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
                    case .updatedData:
                        self?.tableView.reloadData()
                    case .navigateToLogin:
                        self?.performSegue(withIdentifier: "HEROES_TO_LOGIN", sender: nil)
                    case .navigateToDetail:
                        break
                    case .navigateToMap:
                        self?.performSegue(withIdentifier: "HEROES_TO_MAP", sender: nil)
                }
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        viewModel?.logOut()
    }
    
    
    @IBAction func mapButton(_ sender: Any) {
        viewModel?.viewState?(.navigateToMap)
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
        cell.updateViewCell(//id: hero?.id,
                            name: hero?.name,
                            description: hero?.heroDescription,
                            photo: hero?.photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
