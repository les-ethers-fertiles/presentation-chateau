#!/bin/bash

#pour lancer la commande bash, écrire ".././deploiement.sh nomducommiteffectue"

#définition d'une variable pour indiquer le nom de la modification apportée avant nouveau déploiement du site, en argument du script bash
nomducommiteffectue=$1

hugo --destination public

git status && git add . 
git status && git commit -m "$nomducommiteffectue"

git push

#puis le terminal nous demande notre nom d'utilisateur github (ou autre) et notre mot de passe si n'avons pas fait de liaison avec vérification des clés ssh (auquel cas, pas utile).
