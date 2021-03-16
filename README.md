# precommit
Распаковка фалов обработок/отчетов при работе с GIT precommit

Скрипт для выгрузки в файлы внешних обработок и отчетов без использования сторонних приложений 
на платформе Windows с использованием 1С Enterprise и VBS.

В sh запуск vbs с указанием текущего каталога

cscript //NoLogo scripts/precommit.vbs ''"$repoDir"''

Возможности: 
- выполняется распаковка файлов erf,epf.

Планируется: 
- поддержка распаковки cfe.

# Установка:

1. Инициализация. Если у вас уже существует репозиторий, то правильно будет распкавать все текущие файлы erf,epf в каталог src.
Для этого запустите файл parsing allfiles_epf_erf.vbs и выполните push всей новой папки src.

2. Настройка git. Вам необходимо выполнить следующие настройки: 
- Создайле папку scripts в корневом каталоге git и скопируйте файл precommi.vbs.
- Зайти в файл precommit.vbs И указать путь к исполняемому файлу и базе.

apppath = "C:\Program Files\1cv8\8.3.16.1814\bin\1cv8.exe" ' 
serviceib = "/S ServerName/precommit"
- Скопируйте файл precommit в свой репозиторий в папку hooks
- 
3. Проверка. Добавьте тестовую обраотку или измените существуюущу обработку/отчет и выполните коммит.
Скрипт должен отработать и распоковать файлы в каталог src и автоматически их добавить в коммит.
