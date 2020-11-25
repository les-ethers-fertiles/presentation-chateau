#!/bin/bash

#On va là où on veut travailler:
cd /home/habsinn/Bureau/TOUT/Websites_and_Apps/

#On définit les variables (qui seront passées en argument au lancement du fichier bash):
nomchoisidusite=$1 #nom du dossier du site web sur ton ordi
lienpublicgithubdutheme=$2 #lieu où se trouve le theme qu'on veut copier sur Internet (github.com/----.git)
depotgit=$3 #Pour la variable dépôt git, utiliser "ssh://git@forge.openlux.fr:55555/habib/test1000.git" (si clé confirmée) ou "https://forge.openlux.fr/habib/test1000.git" ou "https://github.com/habsinn/NOMCHOISIDUSITE.git"


#On crée un nouveau projet de site web en Hugo:
hugo new site $nomchoisidusite && cd $nomchoisidusite/ 

#Vérification pour voir s'il y a bien une structure Hugo dans le dossier du nouveau projet de site web et on se place dans le sous-dossier "themes":
ls && cd /home/habsinn/Bureau/TOUT/Websites_and_Apps/$nomchoisidusite/themes/

#On télécharge le template du site web avec lequel on souhaite travailler dans le sous-dossier "themes" 
#et on affiche s'il y a bien eu téléchargement du template:
git clone $lienpublicgithubdutheme && ls -la

#on supprime les éventuels fichiers .git existant dans le thème:
cd /home/habsinn/Bureau/TOUT/Websites_and_Apps/$nomchoisidusite/themes/*/
rm -rf .git .gitignore

#on retourne à la racine du projet de site web
cd /home/habsinn/Bureau/TOUT/Websites_and_Apps/$nomchoisidusite/

#copier site web exemple à la racine du dossier du site web en local
cp -r /home/habsinn/Bureau/TOUT/Websites_and_Apps/$nomchoisidusite/themes/*/exampleSite/* /home/habsinn/Bureau/TOUT/Websites_and_Apps/$nomchoisidusite/
 
#création du dossier public/ à la racine du site
hugo --destination public

#on le convertit en dépôt Git
git init

#on fait un first commit afin que le dépôt devienne actif et prêt à être mis en ligne sur le Gitea de la forge.openlux.fr
git status && git add . 
git commit -m "mise en ligne sur le git public"

#message de rappel pour créer un nouveau dépôt sur le git collaboratif en ligne 
read -p "Avez-vous créé votre dépôt git public? (oui/non)" arg1
while [[ $arg1 -ne "oui" ]] 
do
	read -p "Avez-vous créé votre dépôt git public? (oui/non)" arg1
	if [[ $arg1 -eq "oui" ]]
	then
    		break
 	fi
done #alors la boucle s'arrête et se poursuit

#Mise en ligne dans un dépôt git public (comme indiqué en argument lors du lancement du script)
git remote add origin $depotgit && git push -u origin master




