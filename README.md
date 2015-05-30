# backup
Jest to kolejny prosty skrypt służący do tworzenia backupu danych z VPSa/Dedyka. Skierowany jest on raczej dla użytkowników prywatnych, gdyż przystosowany jest jedynie do backupu jednego katalogu. Udostępniam go w całości na licencji GNU GPL.

Tworzy ona backup bazy na podstawie wzorca (wszystkie bazy zawierające ciąg(...) oraz pliki lokalne użytkownika.

Konfiguracja:

NAME='wojtus' #  Nazwa backupu (format $NAME-dd-mm-YY)
DBUSER='root' #  Uzytkownik lokalnej bazy danych
DBPASS='' #  Haslo do bazy danych
PATTERN='wojtus_%' #  Wzorzec nazwy bazy danych (wyszukuje wszystkich baz zaczynajacych sie od podanej (% sluzy jako informacja gdzie jest ciag dalszy nazwy db))
BACKUPDIR='/var/backups' #  Katalog w ktorym beda przetrzymywane backupy
CURDIR='/home/wojtus' #  Katalog dla ktorego robimy backup (przed public_html)
STOREDDAYS=3 #  Ile dni przechowywany jest backup


Przed użyciem skrypu należy nadać mu uprawnienia execute 

chmod +x ./backup.sh


Nie polecam używać tego skryptu z konta root (jak czegokolwiek).
