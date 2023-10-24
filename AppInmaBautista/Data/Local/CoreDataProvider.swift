//
//  CoreDataProvider.swift
//  AppInmaBautista
//
//  Created by ibautista on 24/10/23.
//

import Foundation
import CoreData

protocol CoreDataProviderProtocol {
    func saveHeroDAO(hero: Hero)
    func loadHeroesDAO()
    func loadHeroeById(id: String)
    func deleteAll()
}

class CoreDataProvider {
    private var moc: NSManagedObjectContext? { CoreDataStack.shared.persistentContainer.viewContext
    }
    
    func saveHeroDAO(hero: Hero) {
        guard let moc,
              let entityHero = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc) else {return}
        var heroDAO = HeroDAO(entity: entityHero, insertInto: moc)
        heroDAO.id = hero.id
        heroDAO.name = hero.name
        heroDAO.heroDescription = hero.description
        heroDAO.photo = hero.photo?.absoluteString
        if let favorite = hero.favorite {
            heroDAO.favorite = favorite
        }
        try? moc.save()
    }
    
    func loadHeroesDAO()  {
        let fetchHeroesDAO = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        guard let moc,
              let heroes = try? moc.fetch(fetchHeroesDAO) else { return }
        
        print ("\(heroes)")
    }
    
    func loadHeroeById(id: String) {
        let fetchHeroesDAO = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        fetchHeroesDAO.predicate = NSPredicate(format: "id = \(id)")
        guard let moc,
              let heroe = try? moc.fetch(fetchHeroesDAO) else { return }
        print("Heroe con id:\(heroe) ")
    }
    
    func deleteAll(){
        let fetchHeroesDAO = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        guard let moc,
              let heroes = try? moc.fetch(fetchHeroesDAO) else { return }
        heroes.forEach { moc.delete($0) }
        try? moc.save()
    }
    
}
