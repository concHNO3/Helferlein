#!/bin/zsh
#
# Skript zum automatischen erzeugen von Bookpages
#
# PDF-zu-Buchheften.sh "Ursprungs.pdf"
#
# Benötigt zsh, pdflatex, texlive, pdfjam und pdfinfo
#
INPUT=$1;
BASIS=$(echo $(basename $INPUT) | sed 's/.pdf//');
PDFBOOK="/usr/texbin/pdfbook"
PAGES=$(pdfinfo "$*" 2>&1 | grep "Pages:" | cut -d ":" -f 2 | sed -e 's/^[ \t]*//');
BC="$(which bc)";
SEITENPROHEFT=20;
HEFTE=$(echo "scale=0 ; $PAGES/$SEITENPROHEFT + 1"| $BC);

echo "Converting $INPUT into Books"
for i in {1..$HEFTE};
do
	UGRENZE=$(echo "scale=0;($i-1)*$SEITENPROHEFT + 1" | $BC);
	OGRENZE=$(echo "scale=0;$i * $SEITENPROHEFT" |$BC);
	NEWNAME="$BASIS""_BOOK_""$(printf "%.4d" $i)"".pdf";
	if [[ $OGRENZE -le $PAGES ]] 
	then
		echo "$NEWNAME von $UGRENZE bis $OGRENZE";
		$PDFBOOK --outfile "$NEWNAME" "$INPUT" "$UGRENZE"-"$OGRENZE";
	else
		OGRENZE=$PAGES
		if [[ $UGRENZE -le $PAGES ]]
		then
			echo "$NEWNAME von $UGRENZE bis $OGRENZE";
			$PDFBOOK --outfile "$NEWNAME" "$INPUT" "$UGRENZE"-"$OGRENZE";
		fi
	fi
done;
