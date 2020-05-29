//
//  Copyright © 2020 lukwol. All rights reserved.
//

import Foundation

/// Manages reading and saving favourite movies from user defaults.
final class FavouritesRepository {
    private let userDefaults = UserDefaults.standard
    private let favouritesKey = "favourites"
    
    init() {
        if userDefaults.value(forKey: favouritesKey) == nil {
            userDefaults.set([Int](), forKey: favouritesKey)
        }
    }
    
    /// All favauirte movies.
    var favourites: Set<Int> {
        Set(userDefaults.value(forKey: favouritesKey) as! [Int])
    }
    
    func setFavourite(movie: Movie) {
        var favourites = self.favourites
        favourites.insert(movie.id)
        userDefaults.set(Array(favourites), forKey: favouritesKey)
    }
    
    func setNotFavourite(movie: Movie) {
        var favourites = self.favourites
        favourites.remove(movie.id)
        userDefaults.set(Array(favourites), forKey: favouritesKey)
    }
    
    func isFavourite(movie: Movie) -> Bool {
        favourites.contains(movie.id)
    }
}
