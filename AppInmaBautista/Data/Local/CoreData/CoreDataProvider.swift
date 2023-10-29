//
//  CoreDataProvider.swift
//  AppInmaBautista
//
//  Created by ibautista on 24/10/23.
//

import Foundation
import CoreData

// MARK: - Protocol -
protocol CoreDataProviderProtocol {
//    var moc: NSManagedObjectContext? { get }
    func saveHeroDAO(hero: Hero)
    func saveLocationDAO(location: Location)
    func loadHeroesDAO() -> HeroesDAO
    func loadLocationsDAO() -> LocationsDAO
    
    func loadHeroeById(id: String) -> HeroesDAO
    func deleteAllHeroes()
    func deleteAllLocations()
}

class CoreDataProvider: CoreDataProviderProtocol {

    private var moc: NSManagedObjectContext? {
        CoreDataStack.shared.persistentContainer.viewContext
    }
    
    // MARK: - Functions - 
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
    
    func saveLocationDAO(location: Location) {
        guard let moc,
              let entityLocation = NSEntityDescription.entity(forEntityName: LocationDAO.entityName, in: moc) else {return}
        let locationDAO = LocationDAO(entity: entityLocation, insertInto: moc)
        locationDAO.id = location.id
        locationDAO.date = location.date
        locationDAO.longitude = location.longitude
        locationDAO.latitude = location.latitude
        locationDAO.heroId = location.hero.id
        
        try? moc.save()
    }
    
    func loadHeroesDAO() -> HeroesDAO {
        let fetchHeroesDAO = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        guard let moc,
              let heroes = try? moc.fetch(fetchHeroesDAO) else {
            print("No hay datos de héroes almacenados")
            return []
        }
        print("Heroes en coredata: \(heroes)")
        return heroes
    }
    
    func loadLocationsDAO() ->LocationsDAO {
        let fetchLocationsDAO = NSFetchRequest<LocationDAO>(entityName: LocationDAO.entityName)
        guard let moc,
              let locations = try? moc.fetch(fetchLocationsDAO) else {
            print("No hay datos de héroes almacenados")
            return []
        }
        print("Localizaciones de Heroes coredata: \(locations)")
        return locations
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
    
    func deleteAllLocations(){
        let fetchLocationsDAO = NSFetchRequest<LocationDAO>(entityName: LocationDAO.entityName)
        guard let moc,
              let locations = try? moc.fetch(fetchLocationsDAO) else { return }
        locations.forEach { moc.delete($0) }
        try? moc.save()
    }
}
