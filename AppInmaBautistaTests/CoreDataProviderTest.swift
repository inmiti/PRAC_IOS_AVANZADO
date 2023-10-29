//
//  CoreDataProviderTest.swift
//  AppInmaBautistaTests
//
//  Created by ibautista on 28/10/23.
//

import XCTest
import CoreData
@testable import AppInmaBautista

final class CoreDataProviderTest: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let persistentContainer = NSPersistentContainer(name: "AppInmaBautista")
        let description = NSPersistentStoreDescription()
        description.shouldAddStoreAsynchronously = false
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("No configurado contenedor persistente: \(error)")
            }
        }
        
        managedObjectContext = persistentContainer.viewContext
        
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        super.tearDown()
        managedObjectContext = nil
    }

    func test_givenCoreDataProvider_whenSaveHero_thenGetValidFetch() throws {
        let hero = HeroDAO(context: managedObjectContext)
        hero.id = "EA1445"
        hero.name = "Goku"
        hero.heroDescription = "Goku es el protagonista de Dragón Ball"
        hero.photo = "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300"
        hero.favorite = true
        
        do {
            try managedObjectContext.save()
        } catch {
            XCTFail("Error al guardar el heroe: \(error)")
        }
        let fetchHero: NSFetchRequest = HeroDAO.fetchRequest()
        fetchHero.predicate = NSPredicate(format: "name == %@", "Goku")
        
        do{
            let heroes = try managedObjectContext.fetch(fetchHero)
            XCTAssertNotNil(heroes.first)
        } catch {
            XCTFail("Error al realizar la consulta: \(error)")
        }
    }
    
    func test_givenCoreDataProvider_whenSaveHero_thenGetInvalidFetch() throws {
        let hero = HeroDAO(context: managedObjectContext)
        hero.id = "EA1445"
        hero.name = "Goku"
        hero.heroDescription = "Goku es el protagonista de Dragón Ball"
        hero.photo = "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300"
        hero.favorite = true
        
        do {
            try managedObjectContext.save()
        } catch {
            XCTFail("Error al guardar el heroe: \(error)")
        }
        let fetchHero: NSFetchRequest = HeroDAO.fetchRequest()
        fetchHero.predicate = NSPredicate(format: "name == %@", "Rosi")
        
        do{
            let heroes = try managedObjectContext.fetch(fetchHero)
            XCTAssertNil(heroes.first)
        } catch {
            XCTFail("Error al realizar la consulta: \(error)")
        }
    }
    
}

