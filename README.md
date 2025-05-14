# Test iOS leboncoin (version 2025)

Basé sur le test technique iOS officiel de leboncoin réalisé en 2021, la version 2025 du même test réalisé par Koussaïla BEN MAMAR. 

## Table des matières
- [Objectifs](#objectifs)
- [Test](#test)
- [Ma solution](#solution)

## <a name="objectifs"></a>Objectifs

Créer une application universelle en Swift. Celle-ci devra afficher une liste d'annonces disponibles sur l'API `https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json`

La correspondance des ids de catégories se trouve sur l'API `https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json`

Le contrat d'API est visualisable à cette adresse :
`https://raw.githubusercontent.com/leboncoin/paperclip/master/swagger.yaml`<br>

**Les points attendus dans le projet sont:**
- Une architecture qui respecte le principe de responsabilité unique
- Création des interfaces avec autolayout directement dans le code (pas de `Storyboard` ni de `XIB`, ni de `SwiftUI`)
- Développement en Swift.
- Le code doit être versionné (Git) sur une plateforme en ligne type GitHub ou Bitbucket
(pas de zip) et doit être immédiatement exécutable sur la branche `master` / `main`
- Aucune librairie externe n'est autorisée
- Le projet doit être compatible pour iOS 16+ (compilation et tests) (en 2021, c'était iOS 12 au minimum, mais on va conserver la règle de 2 versions antérieures)

**Nous porterons également une attention particulière sur les points suivants:**
- Les tests unitaires
- Les efforts UX et UI
- Performances de l'application
- Code Swifty

### Liste d'items
Chaque item devra comporter au minimum une image, une catégorie, un titre et un prix.

Un indicateur devra aussi avertir si l'item est urgent.

### Filtre

Un filtre devra être disponible pour afficher seulement les items d'une catégorie.

### Tri
Les items devront être triés par date.

Attention cependant, les annonces marquées comme urgentes devront remonter en haut de la liste.

### Page de détail
Au tap sur un item, une vue détaillée devra être affichée avec toutes les informations fournies dans l'API.
<br><br>
Vous disposez d'un délai d'une semaine pour réaliser le projet.<br>
Bonne chance. L’équipe iOS a hâte de voir votre projet !

Pour cette version, c'est différent, étant donné que c'est non officiel. Mais s'il y a des développeurs iOS expérimentés qui souhaitent faire une revue du code de ce test, vous êtes les bienvenus.

## <a name="solution"></a>Ma solution

Au niveau architecture modulaire, s'il faut respecter le principe de responsabilité unique (Single Responsibility), il est clair que **l'architecture la plus simple (et celle par défaut de UIKit) étant MVC est à bannir. L'architecture MVP est également à bannir dans ce cas de figure.**. 

La solution utilise **UIKit**. L'ensemble des éléments visuels sont 100% full code, étant donné qu'il est **strictement interdit** dans ce test d'utiliser **SwiftUI**, les **XIB** ou les **Storyboard**.

Aucun framework externe n'est utilisé étant donné qu'ils sont **strictement interdits** dans ce test.

### Difficultés rencontrées