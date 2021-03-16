# precommit
precommit for 1c without add library

Библиотека precommit на vbs, очень простое внедрение.

В sh запуск vbs с указанием текущего каталога

cscript //NoLogo scripts/precommit.vbs ''"$repoDir"''


На данный момент выполняется распаковка файлов erf,epf
При необходимости буде добавлена поддержка распаковки cfe

Распаковка выполняется базой 1с 

Необходимые настройки:
Зайти в файл scripts/precommit.vbs 
И указать путь к исполняемому файлу и базе

apppath = "C:\Program Files\1cv8\8.3.16.1814\bin\1cv8.exe" '
serviceib = "/S ServerName/precommit" ' 

# Установка

1. Предварительно необходимо распкавать все текущие файлы erf,epf в src
Для этого запустите файл parsing allfiles_epf_erf.vbs и выполните push всей новой папки src 

2. Скопируйте файл precommit в свой репозиторий в папку hooks
3. Создайле папку scripts в корневом каталоге git и скопируйте файл precommi.vbs

Попробуйте изменить лубую обработку и выполнить коммит
