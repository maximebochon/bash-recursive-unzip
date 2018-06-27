#!/usr/bin/env bash

# Utilitaire pour désarchiver récursivement des archives ZIP
# indépendamment de l'extension du fichier : .zip, .jar, .war, etc.

# Contrôle des arguments :
#   deux arguments :
#     le chemin du fichier ZIP à désarchiver récursivement
#     un booléan indiquant s'il faut supprimer le fichier en fin d'opération

# Vérification du fichier à traiter :
#   existence
#   accès en lecture
#   nature ZIP

# Détermination du chemin du répertoire de désarchivage
#   chemin du fichier suffixé par $TARGET_DIR_SUFFIX
#   par exemple ".recunz" pour "recursive unzip"
# UNZIP_DIR_SUFFIX=".recunz"
# UNZIP_DIR="${ZIP_FILE}${UNZIP_DIR_SUFFIX}"

# Vérifier absence du répertoire de désarchivage

# Création du répertoire de désarchivage
# mkdir ${UNZIP_DIR}

# Désarchivage dans le répertoire de désarchivage

# Pour chaque fichier présent dans le répertoire de désarchivage
# (quelle qu'en soit la profondeur)
#   Si fichier ZIP (vérification via la commande 'file')
#     désarchiver récursivement ce fichier avec suppression de l'archive

ZIP_TYPE_START="Zip archive data"
# TODO: il y a aussi "Java archive data" !
UNZIP_SUFFIX=".unzip"

SUCCESS=0
FAIL_ARGS_COUNT=1
FAIL_FILE_EXIST=2
FAIL_FILE_READ=3
FAIL_FILE_TYPE=4
FAIL_DIR_CONFLICT=5
FAIL_MAKE_DIR=6
FAIL_UNZIP=7
EXIT_MSG="Abandon"

recursive_unzip()
{
	echo "recursive_unzip $*"

	[ ! $# -eq 2 ] \
	 && echo "Nombre d'arguments différent de 2" \
	 && echo $EXIT_MSG && return $FAIL_ARGS_COUNT

	zip_file=$1
	delete_it=$2

	echo "ZIP file: $zip_file"
	echo "delete it: $delete_it"

	#TODO: valider boolean delete_it
	# ou alors passer par une option -D

	[ ! -e ${zip_file} ] \
	 && echo "Le fichier n'existe pas : $zip_file" \
	 && echo $EXIT_MSG && return $FAIL_FILE_EXIST

	[ ! -r ${zip_file} ] \
	 && echo "Impossible de lire le fichier: $zip_file" \
	 && echo $EXIT_MSG && return $FAIL_FILE_READ

	file_type=$(file --brief ${zip_file})

	echo "file type: ${file_type}"

	[[ ! ${file_type} == ${ZIP_TYPE_START}* ]] \
	 && echo "Il ne s'agit pas d'un fichier ZIP." \
	 && echo $EXIT_MSG && return $FAIL_FILE_TYPE

        unzip_dir=${zip_file}${UNZIP_SUFFIX}

        echo "un-ZIP directory: ${unzip_dir}"

	[ -d "${unzip_dir}" ] \
	 && echo "Le répertoire de destination existe déjà : ${unzip_dir}" \
	 && echo $EXIT_MSG && return $FAIL_DIR_CONFLICT

	echo "Création du répertoire de désarchivage"

	mkdir ${unzip_dir}
	# TODO vérifier $?

	unzip -q ${zip_file} -d ${unzip_dir}

	[ ! $? = 0 ] \
	 && echo "Echec du désarchivage de ${zip_file}" \
	 && echo $EXIT_MSG && return $FAIL_UNZIP

	find ${unzip_dir} -type f | while read f; do
	 #echo "Fichier $f"
	 file_type=$(file --brief $f)
	 [[ ${file_type} == ${ZIP_TYPE_START}* ]] \
         && echo "Fichier ZIP détecté : $f" \
         && recursive_unzip $f true
	 #TODO: gérer le code erreur retour
	done
	
	if [ "${delete_it}" = true ]; then
	 echo "Suppression de l'archive '${zip_file}'"
	 rm ${zip_file}
	else
	 echo "Conservation de l'archive '${zip_file}'"
	fi
}


### TESTS ###

recursive_unzip
echo "Statut d'exécution : $?"
echo

recursive_unzip one_arg
echo "Statut d'exécution : $?"
echo

recursive_unzip one two three_args
echo "Statut d'exécution : $?"
echo

recursive_unzip empty.war true
echo "Statut d'exécution : $?"
echo

recursive_unzip empty.war false
echo "Statut d'exécution : $?"
echo

recursive_unzip wrong.war true
echo "Statut d'exécution : $?"
echo

recursive_unzip valid.war false
echo "Statut d'exécution : $?"
echo
