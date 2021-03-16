# precommit
precommit for 1c without add library

Библиотека precommit на vbs, очень простое внедрение.

В sh запуск vbs с указанием текущего каталога

cscript //NoLogo scripts/precommit.vbs ''"$repoDir"''


На данный момент выполняется распаковка файлов erf,epf
При необходимости будет добавлена поддержка распаковки cfe
Распаковка выполняется базой 1с 

# Установка

1. Предварительно необходимо распкавать все текущие файлы erf,epf в src
Для этого запустите файл parsing allfiles_epf_erf.vbs и выполните push всей новой папки src 

2. Выполнить настройки:
Зайти в файл precommit.vbs 
И указать путь к исполняемому файлу и базе

apppath = "C:\Program Files\1cv8\8.3.16.1814\bin\1cv8.exe" '
serviceib = "/S ServerName/precommit"

3. Скопируйте файл precommit в свой репозиторий в папку hooks
4. Создайле папку scripts в корневом каталоге git и скопируйте файл precommi.vbs

Попробуйте изменить лубую обработку и выполнить коммит
