# Application de prise de Rendez-vous personnalisable

## Introduction

Application web Spring MVC de gestion d'un calendrier de prise de rendez-vous, avec distinction de role user/admin, panel admin,
 envoi de mail, gestion d'upload de photo de profil & documents...

Par **Florine Lefebvre** et **Charlie Darques** dans le cadre de la *SAE S5.A.01 - Frameworks Web* (BUT3 Informatique, 2025-2026).

### Lancer le site

1. Tout d'abord, vous devez créer un fichier `.env` à la racine du projet pour y mettre les infos de votre mail univ-lille :

```
MAIL_USERNAME=prenom.nom.etu
MAIL_PASSWORD=motdepasse
```
2. Ensuite, lancer le script `cleanstart.sh` qui va :
    - clean le projet et le compiler
    - copier les images et documents de tests
    - lancer le projet

3. Enfin, sur votre navigateur, ouvrez `http://localhost:8080` pour accéder au site.

*Pour les prochains lancements, vous pourrez utiliser `start.sh` qui passe le clean du projet (gain de temps)*

4. Pour vous connecter en tant qu'administrateur, connectez vous avec le login `jeremy` et le mot de passe `mot de passe`. 

## Fonctionnalités

### Modifier le thème du site

1. Dans `src/main/resources/static`, ajoutez un dossier `nom-de-votre-site` avec :
    - un logo-s.png (petit logo pour la favicon et le header)
    - un logo.png (grand logo utilisé à la page de connexion)

2. Dans `src/main/resources/application.properties`, modifiez :

```
app.title=Nom de votre site
app.favicon.path=/nom-de-votre-site/logo-s.png
app.logo.path=/nom-de-votre-site/logo.png
```

*Vous pouvez essayer avec `piscine-de-lille` (piscine), `sereni-fit` (salle de sport) et `dunder-mifflin` (entreprise de papier) si vous ne souhaitez pas ajouter un autre thème.*

![](/readme/theme-serenifit.png)
![](/readme/theme-piscinedelille.png)
![](/readme/theme-dundermifflin.png)

### Modifier les détails des créneaux (horaires, durée...)

Dans `src/main/resources/application.properties`, vous pouvez modifier :

| Modification | Ligne dans le fichier |
| - | - |
| Les jours d'ouverture | `app.open_days=MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY` |
| La capacité (le nombre de personne par créneau) | `app.slot.capacity=4` |
| La durée d'un créneau (en minutes) | `app.slot.duration=60` |
| L'heure du début de journée | `app.day.start_time=08:00` |
| L'heure de fin de journée | `app.day.end_time=17:00` |

![](/readme/dayplanning.png)

### Utilisation de l'API

*L'API est, comme précisé dans le sujet, publique. Donc même si
chaque endpoint concerne un role en particulier (admin ou user),
tout le monde y a accès.*

#### Today's List

Liste des créneaux pour une date donnée :

> GET http://localhost:8080/todayslist/{date}

La date est au format ISO 8601 (YYYY-MM-JJ). 
Exemple pour le 3 février 2026 : http://localhost:8080/todayslist/2026-02-03 

#### My appointments

Liste des créneaux à suivre pour la personne donnée :

> GET http://localhost:8080/myappointments/{name}

Le paramètre `name` fait référence au login dans la base de donnée.
Exemple : http://localhost:8080/myappointments/florine

### Accueil : Planning

En se connectant, l'utilisateur a accès au planning général sous forme de calendrier du mois courant. Les jours grisés sont soit déjà passés, soit fermés. En cliquant sur un jour, l'application affiche alors les créneaux disponibles de la journée comme démontré dans la <a href="/#modifier-les-détails-des-créneaux-horaires-durée">capture d'écran plus haut</a>.

![](/readme/accueil.png)

### Comptes

L'utilisateur a accès à une page **Compte**, où il trouvera ses informations personnelles et sa photo de profil (modifiables), la liste des créneaux passés et futurs, avec l'option d'accéder aux documents liés (ex. documents médicaux pour le thème médecin). Il peut aussi annuler ses futurs créneaux.

![](/readme/compte.png)

### Panel Admin

Les utilisateurs qui ont le rôle Administrateur ont accès au **Panel Admin**, qui leur permet de :

- annuler tous les créneaux d'une journée (par exemple en cas d'absence ou d'incident)
- annuler un créneau avec ses réservations liées
- de consulter pour chaque créneau la liste des utilisateurs inscrits ainsi que leur documents
- la possibilité de supprimer la réservation d'un utilisateur

L'annulation d'un créneau envoie automatiquement un mail aux utilisateurs ayant réservé ce dernier.

![](/readme/panel_admin.png)

## Aspects techniques

### Base de donnée

Voici le MCD de l'application : 

![](/bdd/mcd.png)

Et son MLD : 

![](/bdd/mld.png)

Chaque `user` peut réserver un créneau (`slot`), ce qui crée une nouvelle réservation (`booking`). Un utilisateur ne peut réserver un créneau qu'une seule fois, mais peut faire plusieurs réservations tant que ce n'est pas le même créneau. Pour chaque réservation, il peut transmettre plusieurs `documents`, qui seront visibles par l'administrateur. 

### Modèles

| Objet | Utilité/fonctionnement |
|-|-|
| Bookings | Réservation d'un créneau, lie un utilisateur et un créneau |
| BookingId | Clé primaire composite d'un objet Bookings (contient l'identifiant du créneau et le login d'un utilisateur) |
| CancelledDays | Ensemble des jours que l'administrateur a marqué comme annulés |
| CancelledSlots | Ensemble des créneaux que l'administrateur a marqué comme annulés |
| Documents | Ressource donnée par l'utilisateur ou l'administrateur à destination de l'un ou l'autre concernant une réservation (ex : ordonnance si rdv médical, contrat d'adhésion si séance de piscine...) |
| Slots | Créneau horaire d'une séance/d'un rendez-vous |
| SlotVirtual | Créneau "virtuel", qui n'existe pas réellement tant qu'il n'a pas été réservé au moins par une personne, sert à l'affichage des horaires disponibles |
| Users | Utilisateur, administrateur compris | 

### Contrôleurs

| Nom | Utilité/fonctionnement |
|-|-|
| Compte | Accès à la page 'compte', l'espace personnel de chaque utilisateur. Permet de voir et modifier les informations du compte, de consulter les évènements passés/à venir, et d'ajouter des documents à une réservation |
| DayPlanning | Affichage des créneaux pour une date donnée, permet de faire une réservation |
| DocumentsController | Affichage des documents relatifs au créneau donné, permet de téléverser un nouveau document ou d'en supprimer |
| LoginSignin | Contrôleur de connexion/inscription, gère l'affichage de la page de connexion, l'inscription donc la création d'un nouvel utilisateur, et la déconnexion. Il est complémenté par **Spring Security** | 
| PanelAdmin | Vue de l'application uniquement réservée à l'administrateur, permet de supprimer des créneaux, banaliser des journées, annuler des rendez-vous, consulter le profil et les documents des utilisateurs de chaque créneau |
| Planning | "Landing page", page d'accueil qui fait office de calendrier du mois courant où chaque jour amène sur le DayPlanning correspondant |

### Fonctionnement du systèmes d'authentification 

L'application utilise **Spring Security** pour gérer l'authentification et la gestion des mots de passe. Le formulaire de connexion est géré par Spring Security qui vérifie si l'utilisateur existe, si son mot de passe (encodé en **Bcrypt**) est correct, et le rôle qui lui a été attribué. 
Une option *"remember-me"* est possible à la connexion, ce qui évite de devoir se reconnecter à chaque visite.

### Ce qui a pris du temps

Nous devions ajouter progressivement de nouveaux éléments appris au fur et à mesure sur Spring (MVC, Security...) donc restructurer le projet à chaque ajout a pris un certain temps.

Nous avons eu quelques difficultés avec la manière de modéliser les créneaux dits "virtuels", il fallait qu'ils soient affichés de manière régulière, systématique, sans pour autant être enregistrés en base de données. Aussi, il fallait pouvoir annuler certains créneaux, ou certains jours, encore une fois sans que ce soit stocké en base. Réfléchir sur ces points et mettre en place la solution trouvée nous a pris un long moment.

La mise en place de Spring Security a aussi pris plus de temps que ce qu'on imaginait. Il a fallu restructurer notre propre système de sécurité et d'authentification pour ajuster le code existant au fonctionnement de Spring Security, ce qui a pu être chronophage car il fallait vérifier l'intégralité du code pour ne rien oublier.

## Conclusion

Ce projet avait pour objectif de réaliser une application se rapprochant le plus possible d'une plateforme professionnelle, de comprendre les principes et les fonctionnements de Spring pour ensuite les implémenter dans un projet répondant à un besoin concret. 

Les difficultés rencontrées ont été relatives à la modélisation, l'implémentation de certains éléments plus abstraits ("faux" créneaux) ou de Spring Security, à la manière de configurer l'application (nom, logo, jours ouverts, durée des créneaux...). Parfois il a simplement s'agit de formatage de date à l'affichage, qui s'est avéré plus compliqué que prévu. 

Nous avons beaucoup appris, sur le fonctionnement de Spring, sur ses avantages, ses limites, sur Maven, sur l'intégration de différentes langues dans une même application, sur l'importance d'un projet correctement structuré pour qu'il soit adapté à l'arborescence Spring. Nous avons acquit énormément de connaissances en web, en back-end, qui nous serviront sans aucun doute dans le futur.

L'application est terminée, mais nous pourrions éventuellement envisager d'ajouter certaines fonctionnalités : plus de langues disponibles, messagerie privée entre administrateur et client, envoi des mails dans la langue choisie par l'utilisateur, et faire en sorte que les jours/créneaux annulés soient persistants.