#!/bin/bash
# file: josm
# josm.sh parameter-completion

_getlocality ()   #  By convention, the function name
{                 #+ starts with an underscore.
  local cur
  # Pointer to current completion word.
  # By convention, it's named "cur" but this isn't strictly necessary.

  COMPREPLY=()   # Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]}

  case "$cur" in
    *)
    COMPREPLY=( $( compgen -W '`ls -d maps/*/ | xargs -n1 basename`' -- $cur ) );
#   Generate the completion matches and load them into $COMPREPLY array.
#   xx) May add more cases here.
#   yy)
#   zz)
  esac

  return 0
}

_openmap (){
    locality=(`ls -d $dir/*/ | xargs -n1 basename | grep -i ^$arg1`)
    #echo ${#locality[@]}
    if [ ${#locality[@]} -gt 1 ]; then
        echo 'ВНИМЕНИ! Много совпадений! Укажи название точнее!'
        source  ./josm.sh $arg1
        echo ${locality[@]}
    elif [ ${#locality[@]} -lt 1 ]; then
        echo 'Не найдено такого названия'
        echo 'Введите название из этого списка'
        echo `ls -d $dir/*/ | xargs -n1 basename`
    else
        # Run Sublimetext project
        subl ./

        # Run qgis project
        (qgis ./qgis/project.qgs &)

        bbox="`cat $dir/${locality[0]}/bbox`"
        echo java -Xmx1024M -jar josm/josm-latest.jar $dir/${locality[0]}/${locality[0]}.geojson $bbox
        java -Xmx1024M -jar josm/josm-latest.jar $dir/${locality[0]}/${locality[0]}.geojson $bbox

        #make snapchot
        bboxlonlat="`cat $dir/${locality[0]}/bbox_lonlat`"
        echo wget "http://render.openstreetmap.org/cgi-bin/export?bbox=$bboxlonlat&scale=10000&format=png" -O $dir/${locality[0]}/snapshot.png
        wget "http://render.openstreetmap.org/cgi-bin/export?bbox=$bboxlonlat&scale=10000&format=png" -O $dir/${locality[0]}/snapshot.png
    fi
}

complete -F _getlocality -o filenames ./josm.sh start

arg1="$1"
dir="maps"

if [ -z "$arg1" ]; then
    arg1="`ls -dt $dir/*/ | head -1 | xargs -n1 basename | head -1`"
    touch $dir/$arg1
    echo "Введи название деревни"
    echo "Например: ./josm.sh Абалак"
    echo "Сейчас откроеться последний редактируемый населенный пункт $arg1"
    _openmap arg1
else
    _openmap arg1
fi





