#!bin/sh
#initialisation des variables
nb_coord_j1=1
nbligne=5
nbcol=5
total_bombe_plateau=5
# fonction de construction du champ

affiche_plateau_j2 () {
ligne=1
col=1
while [ "$ligne" -le $nbligne ]
do
	while [ "$col" -le $nbcol ]
	do
		if grep -q $col${ligne} coordj2.txt  # → concaténation des chaines de caractéres dans le fichier txt
		then
			nbbombe=$(grep -w $col${ligne} coordj2.txt)   #récupère le contenu de la ligne dans le fihcier
			#nbbombe=$((${nbbombe:3}))	#commence à la position 3 de la chaine (exemple 12:2 --> récupère 2)
			nbbombe=`expr substr $nbbombe 4 1`
			printf $nbbombe
		else
			printf "."
		fi
		col=$(( $col +1 ))
	done
echo ""
col=1
ligne=$(( $ligne +1 ))
done
}



affiche_plateau_final () {
ligne=1
col=1
while [ "$ligne" -le $nbligne ]
do
	while [ "$col" -le $nbcol ]
	do
		if grep -q $col${ligne} coord_bomb.txt  # → concaténation des chaines de caractéres dans le fichier txt
		then
			printf "x"
		else
			printf "."
		fi
		col=$(( $col +1 ))
	done
echo ""
col=1
ligne=$(( $ligne +1 ))
done
}

verifier_nb_bombes(){

coord_a_tester=$1
bombe=0
#vérification des cases à proximité
	if grep -q -w $(( $coord_a_tester -11 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
	if grep -q -w $(( $coord_a_tester -10 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
	if grep -q -w $(( $coord_a_tester -9 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
	if grep -q -w $(( $coord_a_tester -1 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
	if grep -q -w $(( $coord_a_tester +1 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
	if grep -q -w $(( $coord_a_tester +9 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
	if grep -q -w $(( $coord_a_tester +10 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
	if grep -q -w $(( $coord_a_tester +11 )) coord_bomb.txt
	then
		bombe=$(( $bombe +1 ))
	fi
echo $coord_a_tester":"${bombe} >> coordj2.txt
return $bombe
}

#supprime le fichier si il est deja existant
if [ -w coord_bomb.txt ]
then
	rm coord_bomb.txt
fi
if [ -w coordj2.txt ]
then
	rm coordj2.txt
	printf "" >> coordj2.txt
fi
#le joueur 1 place ses mines
echo "Le joueur 1 rentre les coordonnées des 5 mines"
while [ "$nb_coord_j1" -le "$total_bombe_plateau" ]
do
	echo "Entrer coordonnée no "$nb_coord_j1
	read coord_joueur1
	while [ "$coord_joueur1" -lt 11 -o "$coord_joueur1" -gt $nbligne${nbcol} ]
	do
		echo "Veuillez renseigner des coordonnées comprises entre 11 et " $nbligne${nbcol}
		read coord_joueur1
	done
	echo $coord_joueur1 >> coord_bomb.txt
	nb_coord_j1=$(( $nb_coord_j1 +1 ))

done
clear
#permet de vérifier si les coordonnées sont identique à celle de coord_bomb.txt
essai=1
while [ "$essai" -le 20 ]
do

echo "Le joueur 2 rentre des coordonnées comprises entre 11 et " $nbligne${nbcol}
read coord_joueur2
if grep -q $coord_joueur2 coordj2.txt
then
	echo "Vous avez déja renseigné ces coordonnées"
else
	if grep -q $coord_joueur2 coord_bomb.txt
	then
		echo "perdu"
		affiche_plateau_final
		sleep 10
		exit
	else
		verifier_nb_bombes $coord_joueur2
		#bombe=$?  #$? récupère la valeur de retour de la fonction verifier_nb_bombes
		#echo "bombe :" $bombe
		#echo "gagné"
		affiche_plateau_j2
		nb=$(wc -l < coordj2.txt)
		if [ $nb -eq $((nbligne*nbcol-total_bombe_plateau)) ]
		then
			echo "Vous avez gagné"
			sleep 10
		exit
		fi
	fi
essai=$(( $essai +1 )) # → compte les essais
fi

done
# pour quitter le jeu
read -p "Pressez une touche pour quiter" quit


