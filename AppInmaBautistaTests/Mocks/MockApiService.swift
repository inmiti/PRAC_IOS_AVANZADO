//
//  MockApiService.swift
//  AppInmaBautistaTests
//
//  Created by ibautista on 28/10/23.
//

import Foundation
import AppInmaBautista

class MockApiService: ApiProviderProtocol {
    private let responseDataToken: [String: String] = ["token" : "a1b2c3"]
    
    private let responseDataHeroes: [[String:Any]] = [
        [
            "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300",
            "name": "Maestro Roshi",
            "id": "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
            "description": "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales. Aún en los primeros episodios había un toque de tradición y disciplina, muy bien representada por el maestro. Pero Muten Roshi es un anciano extremadamente pervertido con las chicas jóvenes, una actitud que se utilizaba en escenas divertidas en los años 80. En su faceta de experto en artes marciales, fue quien le enseñó a Goku técnicas como el Kame Hame Ha",
            "favorite": false
        ],
        [
            "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-satan.jpg?width=300",
            "name": "Mr. Satán",
            "id": "1985A353-157F-4C0B-A789-FD5B4F8DABDB",
            "description": "Mr. Satán es un charlatán fanfarrón, capaz de manipular a las masas. Pero en realidad es cobarde cuando se da cuenta que no puede contra su adversario como ocurrió con Androide 18 o Célula. Siempre habla más de la cuenta, pero en algún momento del combate empieza a suplicar. Androide 18 le ayuda a fingir su victoria a cambio de mucho dinero. Él acepta el trato porque no podría soportar que todo el mundo le diera la espalda por ser un fraude.",
            "favorite": false
        ],
        [
            "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300",
            "name": "Krilin",
            "id": "D88BE50B-913D-4EA8-AC42-04D3AF1434E3",
            "description": "Krilin lo tiene todo. Cuando aún no existían los 'memes', Krilin ya los protagonizaba. Junto a Yamcha ha sido objeto de burla por sus desafortunadas batallas en Dragon Ball Z. Inicialmente, Krilin era el mejor amigo de Goku siendo sólo dos niños que querían aprender artes marciales. El Maestro Roshi les entrena para ser dos grandes luchadores, pero la diferencia entre ambos cada vez es más evidente. Krilin era ambicioso y se ablanda con el tiempo. Es un personaje que acepta un papel secundario para apoyar el éxito de su mejor amigo Goku de una forma totalmente altruista.",
            "favorite": false
        ]
    ]
    
    func getHeroes(token: String?, completion:((AppInmaBautista.Heroes),
                                (AppInmaBautista.NetworkErrors)) -> Void)
}
