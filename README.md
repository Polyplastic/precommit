# precommit
precommit for 1c without add library

Библиотека precommit на vbs

В sh запуск vbs с указанием текущего каталога

На данный момент выполняется распаковка файлов erf,epf
При необходимости буде добавлена поддержка распаковки cfe

Распаковка выполняется базой 1с 

Необходимые настройки:
Зайти в файл scripts/precommit.vbs 
И указать путь к исполняемому файлу и базе

apppath = "C:\Program Files\1cv8\8.3.16.1814\bin\1cv8.exe" '
serviceib = "/S ServerName/precommit" ' 
