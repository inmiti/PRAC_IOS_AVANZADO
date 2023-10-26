//
//  CoreDataProvider.swift
//  AppInmaBautista
//
//  Created by ibautista on 24/10/23.
//

import Foundation
import CoreData

protocol CoreDataProviderProtocol {
    var moc: NSManagedObjectContext? { get }
    func saveHeroDAO(hero: Hero)
    func loadHeroesDAO()
    func loadHeroeById(id: String) -> [HeroDAO]
    func deleteAllHeroes()
}

class CoreDataProvider {
    var moc: NSManagedObjectContext? { CoreDataStack.shared.persistentContainer.viewContext
    }
    
    func saveHeroDAO(hero: Hero) {
        guard let moc,
              let entityHero = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc) else {return}
        let heroDAO = HeroDAO(entity: entityHero, insertInto: moc)
        heroDAO.id = hero.id
        heroDAO.name = hero.name
        heroDAO.heroDescription = hero.description
        heroDAO.photo = hero.photo?.absoluteString
        if let favorite = hero.favorite {
            heroDAO.favorite = favorite
        }
        try? moc.save()
    }
    
    func loadHeroesDAO() -> [HeroDAO] {
        let fetchHeroesDAO = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        guard let moc,
              let heroes = try? moc.fetch(fetchHeroesDAO) else {
            print("No hay datos de héroes almacenados")
            return []
        }
        return heroes
    }
    
    func loadHeroeById(id: String) -> [HeroDAO] {
        let fetchHeroesDAO = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        fetchHeroesDAO.predicate = NSPredicate(format: "id = \(id)")
        guard let moc,
              let heroe = try? moc.fetch(fetchHeroesDAO) else {
            print("Noy hay ese héroe almacenado")
            return []
        }
        print("Heroe con id:\(heroe) ")
        return heroe
    }
    
    func deleteAllHeroes(){
        let fetchHeroesDAO = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        guard let moc,
              let heroes = try? moc.fetch(fetchHeroesDAO) else { return }
        heroes.forEach { moc.delete($0) }
        try? moc.save()
    }
    
}
