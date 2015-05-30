#!/bin/bash

# Backup bazy danych i plikow lokalnych
# Utworzono: 13.04.2015r
# Autor: Wojciech Pitek
# Licencja: GNU GPL

NAME='wojtus' # Nazwa backupu (format $NAME-dd-mm-YY)
DBUSER='root' # Uzytkownik lokalnej bazy danych
DBPASS='' # Haslo do bazy danych
PATTERN='wojtus_%' # Wzorzec nazwy bazy danych (wyszukuje wszystkich baz zaczynajacych sie od podanej (% sluzy jako informacja gdzie jest ciag dalszy nazwy db))
BACKUPDIR='/var/backups' # Katalog w ktorym beda przetrzymywane backupy
CURDIR='/home/wojtus' # Katalog dla ktorego robimy backup (przed public_html)
STOREDDAYS=3 # Ile dni przechowywany jest backup

# Do not modify below

SQLDIR="sql"
DAT=`date +"%d-%m-%Y"`
BCDIR="$CURDIR/$NAME-$DAT"

if [[ -e $BCDIR ]] ; then
	echo "Katalog $BCDIR istnieje! Tworze nowy.."
	rm -fR $BCDIR
fi

mkdir $BCDIR
mkdir $BCDIR/$SQLDIR

echo "Katalog $BCDIR stworzony."
echo "Rozpoczynam dump bazy danych $PATTERN.."

for q in `mysql -u$DBUSER -p$DBPASS -e "SHOW DATABASES LIKE '$PATTERN'" 2>/dev/null | grep -Ev "(Database|$PATTERN)"` ; do
	echo "Tworze backup bazy $q..."
	mysqldump --force --opt --login-path=local -u$DBUSER -p$DBPASS $q >> $BCDIR/$SQLDIR/$q.sql 2>/dev/null
	echo "Backup bazy $q utworzony!"
done

echo "Tworzenie backupu bazy ukonczone!"
echo "Kopiowanie katalogu $CURDIR/public_html.."

cp -fR $CURDIR/public_html $BCDIR 2>/dev/null

echo "Kopia katalogu $CURDIR/public_html utworzona!"
echo "Pakuje backup..."

tar -zcf "$NAME-$DAT.tar.gz" $BCDIR 2>/dev/null

echo "Backup spakowany!"

rm -fR $BCDIR 2>/dev/null

for f in `ls | grep $NAME-*.tar.gz` ; do
	if [[ `stat -c %Y $BACKUPDIR/$f` -lt $(( `date +'%s'` - 60*60*24*$STOREDDAYS )) ]] ; then
		rm -f $BACKUPDIR/$f 2>/dev/null
		echo "Usunieto backup: $f"
	fi
done

echo "Przenosze backup do katalogu $BACKUPDIR.."
mv -f $BCDIR.tar.gz $BACKUPDIR 2>/dev/null

echo "Backup utworzony!"

exit 0
