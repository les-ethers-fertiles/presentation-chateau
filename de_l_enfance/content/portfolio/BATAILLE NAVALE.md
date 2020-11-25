+++
draft = false
image = "img/portfolio/paper-presentation.jpg"
showonlyimage = true
date = "2016-11-05T20:23:59+05:30"
title = "Item with image"
weight = 3
+++

# Jeu de bataille navale en reseau

## Introduction: lecture du sujet 

A la lecture, je me pose les questions suivantes et identifient des ressources en ligne pour y repondre:
* Comment fonctionne une communication TCP de 1 client a 1 serveur? Et de 2 clients (ou +) au meme serveur?
    * difference entre port et socket : https://medium.com/fantageek/understanding-socket-and-port-in-tcp-2213dc2e9b0c
    * cours de reseau - TP 5 
    * creer et confirmer une connexion client vers serveur en ecoute : https://www.tutorialspoint.com/python/python_networking.htm
    * https://www.youtube.com/watch?v=Lbfe3-v7yE0
    * envoi et reception de donnees entre 1 client et 1 serveur (notion de buffer en +) : https://www.w3schools.in/python-tutorial/network-programming/#Defining_Socket
    * https://www.geeksforgeeks.org/socket-programming-python/
    * comprendre select.select, et saisir la difference entre socket, port, connexion et nombre et fonction des file descriptors ouverts lors d'une connexion en TCP: 
        * https://pymotw.com/2/select/
        * https://www.youtube.com/watch?v=2ukHDGLr9SI

    * comprendre le threading pour des connexion multi-clients : https://www.geeksforgeeks.org/socket-programming-multi-threading-python/
    * https://realpython.com/python-sockets/#multi-connection-client-and-server
        * autres ressources interessantes trouvees sur la route pour les notions de reseau en general (pas utiles dans notre cadre cependant): http://xahlee.info/linux/tcp_ip_tutorial.html

* Comment chaque client peut-il recuperer sur sa machine des donnees qui se repondent entre elles, cad suivre  une meme histoire qui se deroule chacun sur leur machine (de maniere relativement synchrone, pour eviter qu'une partie ne dure plusieurs heures, voire jours: on imagine que les deux joueurs restent face a leur ecran concentres sur la meme partie au meme moment)? Et sous quelle forme (comment ces donnees s'affichent-elles de maniere lisibles pour la personne qui est face a son ecran cote client)?
    * cours de reseau -TP 5
    * https://realpython.com/python-sockets/ --> *" accept() : blocks and waits for an incoming connection. When a client connects, it returns a new socket object representing the connection and a tuple holding the address of the client. The tuple will contain (host, port) for IPv4 connections or (host, port, flowinfo, scopeid) for IPv6. See Socket Address Families in the reference section for details on the tuple values.One thing that's imperative to understand is that we now have a new socket object from accept(). This is important since it's the socket that you'll use to communicate with the client. It's distinct from the listening socket that the server is using to accept new connections"*
* Que signifie "etablir un protocole textuel ascii"? Quel autre type de protocole pourrait-on avoir?
    * https://stackoverflow.com/questions/5909873/how-can-i-pretty-print-ascii-tables-with-python
    * https://stackoverflow.com/questions/11741574/how-to-print-utf-8-encoded-text-to-the-console-in-python-3
    * https://codereview.stackexchange.com/questions/122970/python-simple-battleship-game
    * https://realpython.com/python-encodings-guide/
    * https://www.devdungeon.com/content/create-ascii-art-text-banners-python
    * http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
* Que veut dire choisir "comment chaque client fait son affichage, independamment du protocole"? Que le meme protocole doit fonctionner pour differentes facon d'afficher les coups joues, la grille et les resultats?

## 1) Premiere lecture du code source
Au terme de cette premiere lecture, j'en conclus que: 
- je ne suis pas sur de comment fonctionne une liste et ses methodes dans python (append, remove, ...)
    - https://www.w3schools.com/python/python_lists.asp
- je ne sais pas comment fonctionne une **classe** d'objets
    - https://www.w3schools.com/python/python_classes.asp
    - je ne comprends pas le **_ _init_ _**
        - https://www.w3schools.com/python/python_classes.asp
        - "All classes have a function called __init__(), which is always executed when the class is being initiated.Use the __init__() function to assign values to object properties, or other operations that are necessary to do when the object is being created"
- qu'est-ce que **def**,  qu'est-ce que **return**?
    - https://www.learnpython.org/en/Functions

- qu'est-ce que **ord** et **chr** (ont l'air de typage)?
    - 
- il n'y a pas de **try...except** dans ce code, faut-il le rajouter ?
- regarder comment passer un argument a l'appel d'un programme sur python?
    - https://www.pythonforbeginners.com/system/python-sys-argv
## 2) Rappel des principes generaux d'une communication  TCP serveur-client, et serveur-multi-clients
- J'ai demande a Florian et Simon quelles etaient les notions et supports en jeu pour savoir par ou commencer. 
    - Florian m'a conseille de voir le TP 5 en entier pour commencer, ce que je fais:
        - sujet
        - corrections: 
            - echo-tcp
            - echo-udp
            - echo-tcp-select
                - setsockopt?
                - l.remove? 
            - echo-tcp-thread
            - chat
            - chat-thread
    - Simon m'indique que pour une connexion TCp, il faut bien faire la distinction entre le premier FD de la connexion et le deuxieme FD de lecture/ecriture

## 3) Je teste le jeu seul face a la machine en mode verbose

1. Je me place dans le dossier decompresse ou se trouvent les 2 fichiers main.py et game.py
`cd ~/chemin_du_dossier_ou_se_trouvent_main_et_game`
2. Je rends les 2 fichiers executables pour pouvoir les lancer
`chmod +x game.py main.py` 
--> Je verifie que c'est bien le cas avec`ls -l *.py`
C'est OK.
3. Je lance le main.py (qui importe lui-meme toutes les fonctions dont il a besoin pour le bon fonctionnement du jeu depuis le fichier game.py), et commence une partie avec la machine. Tout fonctionne.
4. Par megarde, je tape + d'un caractere en renseignant une colonne, et j'obtiens une rreur qui me fait quitter la partie en cours. 
5. Je m'apercois que je dois en recommencer une depuis le debut en relancant le script. Et me demande comment garder une copie d'une partie en cours si un des 2 joueurs se connectent pour cause de renvoie d'erreur ou deconnexion de la machine en cours de partie, afin de pouvoir reprendre la ou il en etait.


## 4) Relecture detaillee du code source et actions:
#### 4-a) Je relis le code source et comment chaque etape de la fonction principale du main.py, qui correspond a l'algorythme de deroulement d'une partie

#### 4-b) Sous forme d'un schema, je retranscris le deroule de ces etapes etape par etape des echanges d'informations entre les 2 clients qui jouent ensemble en passant par le meme serveur
J'y ajoute egalement les input/output generes par le code source a chaque etape d'une partie, pour mieux visualiser les echanges attendus entre un client et un serveur.
[photo des annotations sur le main.py, page 2]
#### 4-c) Debut de l'ecriture du code : 
NB: Les paragraphes, A), B1), B2), etc, sont nommes de la meme maniere que dans les commentaires du programme que j'ai ecrit. 

##### 4-c) - A)serveur et B1)client: lancement du programme du serveur sans argument, et sur les clients, lancement du programme avec le nom du serveur en parametre
- problemes rencontres : usage de sys.argv[1] --> convertir en str() pour pouvoir utiliser une variable qui le contient.
    - source qui m'a servi: https://www.pythonforbeginners.com/argv/more-fun-with-sys-argv
- probleme de format de donnees renvoyees par le serveur : rajout de bytes() dans le c.send()
    - source qui m'a servi: https://www.youtube.com/watch?v=Lbfe3-v7yE0
-   J'ai tente d'utiliser une variable `host_ip = socket.gethostbyname('host_name') ` dans l'idee d'inclure une resolution du hostname au sein du programme pour que chaque client puisse taper n'importe quel hostname meme s'il n'en connait pas l'adresse IP, mais sans succes. Je n'ai fait que recevoir une erreur en retour : `socket.gaierror: [Errno -5] No address associated with hostname` . Je n'ai pas reussi au bout d'1 heure environ et j'ai choisi d'abandonner le .gethostname() pour le moment. Il faut ecrire l'IP complet pour le moment, que l'on passe en argument lors du lancement du programme cote client.
- Sur le programme du serveur, j'ai voulu visualiser que le socket d'ecoute et le socket de communication (envoi/reception de messages avec des clients) etaient bien differentes en ajoutant la variable s dans le print:`print("Socket successfully created:",s)`ce qui me renvoyait en stdout
 :`Socket successfully created: <socket.socket fd=3, family=AddressFamily.AF_INET6, type=SocketKind.SOCK_STREAM, proto=0, laddr=('::', 0, 0, 0)>`, et en rajoutant la variable d'output c correspondant a la connexion du socket de communication dans un print `print("Got connection from", addr,c)`, ce qui me renvoyer en stdout `Got connection from ('::ffff:127.0.0.1', 33824, 0, 0) <socket.socket fd=4, family=AddressFamily.AF_INET6, type=SocketKind.SOCK_STREAM, proto=0, laddr=('::ffff:127.0.0.1', 1234, 0, 0), raddr=('::ffff:127.0.0.1', 33824, 0, 0)` . J'ai ainsi pu observer que les file descriptors (fd=3 et fd=4 sont bien differents, et que le fd du socket d'ecoute ne possede pas de champ raddr qui correspond au parametre d'identification du client connecte sur le second socket de connexion).

##### 4-c) - B2)serveur:  creation et gestion des sockets de connexion des 2 clients
- Ne comprenant pas en detail comment fonctionne select, je decide d'utiliser d'abord les fonctions de 'threading', en faisant un copier-coller du cours echo-chat-thread, mais ne comprend exactement comment cela fonctionne au niveau des blocages et deblocages de fils de processus. J'obtiens des erreurs que je ne saisis pas bien, du type : 
```
Exception in thread Thread-1:
Traceback (most recent call last):
  File "/usr/lib/python3.7/threading.py", line 917, in _bootstrap_inner
    self.run()
  File "/usr/lib/python3.7/threading.py", line 865, in run
    self._target(*self._args, **self._kwargs)
  File "./serveur_mybattleship.py", line 32, in f
    new_connection, address = s.accept()
ConnectionResetError: [Errno 104] Connection reset by peer
```
Apres avoir demande a Simon ce qu'il en pense, celui-ci m'invite a plutot utiliser la fonction select.select() et m'explique clairement comment elle marche. 
Je comprends qu'elle me permet d'identifier facilement quelles sont les sockets en cours d'usages et donc de choisir sur laquelle je souhaite recevoir ou envoyer des donnees. Je vais donc facilement pouvoir assigner 2 sockets a chacun des joueurs, en admettant qu'ils n'effectuent pas une deconnexion-reconnexion en cours de partie, auquel cas, la partie serait perdue et devrait alors etre reinitialisee par les 2 clients.
J'ecris alors le code du paragraphe B1) sur le programme du serveur.
 
##### 4-c) - C1)client: envoi des reponses de confirmation par chaque client
- apres avoir ecrit le paragraphe C1 cote client, je rencontre un bug que je ne comprends pas et decouvre l'outil `pdb.set_trace()` sur les conseils de Simon, qui est une fonction que l'on insere dans un endroit du programme ou l'on souhaite observer ce qui bug de maniere plus fine, pour tenter de debugger. Dans ce cas, le bug obtenu etait le suivant:
alors que le client envoie (ligne 34, c.send()) le contenu du prompt (oui/non), le serveur recoit bien la reponse en octets (symbole 'b' pour bytes devant la reponse, mais aussi une reponse vide juste a la suite qui le fait rentrer dans la boucle `if` suivante et effectuer un `new_connection.close()`.
Finalement, en tapant *"python issue c.recv two messages including 1 empty from input on client side"* dans le moteur de recherche, je tombe sur un lien (source: https://docs.python.org/2/howto/sockets.html) qui me donne la reponse "*When a recv returns 0 bytes, it means the other side has closed (or is in the process of closing) the connection"* . Je comprends alors que c'est tout simplement parce que mon programme se termine cote client que le serveur recoit une information vide d'octets.
Je choisis alors une solution temporaire pour pouvoir continuer de coder cote serveur, et ajoute un `time.sleep(5)` en fin de programme cote client.

##### 4-c) - C2)serveur: confirmation des joueurs, lancement et deroulement d'une partie
- Je me penche sur l'initialisation d'une partie et deroule dans un premier temps les lignes de code de maniere assez fluide:
	- d'abord, je recupere les premieres lignes de la fonction main() et les renvoie a chaque joueur en assignant a chacun un socket de commuication distinct
	- ensuite, j'ecris comment gerer la reception et le renvoi des reponses d'un joueur a l'autre
			- a ce moment-la je me questionne: est-il possible qu'un joueur envoie plusieurs fois de suite un message, ce qui parasiterait l'enchainement logique des coups?
			  Est-il utile de considerer les fonction de threading ici, afin de bloquer chaque enchainement de couple"reception du message d'un joueur-renvoi du message a l'autre joueur"?
			- je realise alors que je ne suis pas sur de l'endroit ou l'ensemble du deroulement d'une partie doit etre positionne dans le code?
			  C'est le string=new_connection.recv() et le l.remove(new_connection) qui me font hesiter : ou doivent-ils apparaitre dans l'ordre d'enchainement des instructions par rapport au code du deroulement d'une partie?
			- je fais alors des aller-retour entre le pargraphe B2)serveur et C2)serveur, pour finalement saisir que la partie doit se derouler dans B2) au sein du 2eme cas de figure, 
			qui est celui de la reception de donnees par les sockets de communication. 
			Au sein de ce dernier, on doit distinguer 2 sous-cas de figure: 
			
##### 4-c) - D1)client: lancement et deroulement d'une partie
			- pas de decouvertes ou de blocage particulier a cette etape
				
##### 4-c) - E)F)client: cloture d'une partie
			- pas de decouvertes ou de blocage particulier a cette etape
				
##### 4-c) - FIN: lancement du code sur 3 terminaux bash pour simuler 2 clients qui se connectent a un serveur.
			- la premiere surprise est grande : lorsque je lance les programmes. Les 3 terminaux m'affichent la meme chose: a savoir directement la grille d'une partie , avant meme les confirmations de connexion entre client et serveur. *Sentiment de panique*. Je me dis qu'il y a un principe fondamental d'ordonnation ou d'import des fichiers python... 
			En testant le jeu sur chaque temrinal, je comprends que je joue contre la machine sur les 3 terminaux. Comme si mes 2 programmes allaient chercher directement la fonction main()
			Je decide de me concentrer sur la ligne `from mainbattleship import *` et tente instinctivement la chose suivante : dans le mainbattleship.py (copie du fichier main.py), je supprime les lignes de code relatives a la creation de la fonction `def main()`
			Je relance le programme: le debut du programme marche a nouveai, puisque j'obtiens : 
```
habsinn@habsinn:~/Bureau/TOUT/Cours_fac/bataille$ ./serveur_mybattleship2.py 
Socket cree sans probleme
socket relie au port 1234
Le socket est en ecoute de nouvelles connexions clients
Un nouveau client vient de se connecter:  ('::ffff:127.0.0.1', 59550, 0, 0)
Un nouveau client vient de se connecter:  ('::ffff:127.0.0.1', 59552, 0, 0)
```
			- je peux alors me lancer dans debuggage en lisant les messages d'erreur rencontres: oubli d'arguments, erreurs de typographies dans le nom des variabls,...
			- je rencontre alors un nouveau probleme: je m'apercois que le programme n'avance plus apres l'envoi des 2 reponses 'oui' par chacun des 2 clients
			- je tente de reutiliser l'outil `pdb.set_trace()`. En le positionnant a differentes lignes par supposition, je finis par voir que cela ne semble pas fonctionner au niveau des lignes 44 et 62 de mon programme.

#### 4-d) Prochaines etapes identifiees si l'ecriture du code doit se poursuivre:
- gestion de plus de 2 clients, notamment si l'un des deux s'est deconnecte
 
## Avant-dernier : tutoriel d'installation et usage du jeu

## FIN: mise en forme telle que demandee  (rapport, tar, droits rwx)