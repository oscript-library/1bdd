# language: ru

Функционал: Выполнение файловых операций
    Как Пользователь
    Я хочу иметь возможность выполнять различные файловые операции в тексте фич
    Чтобы я мог проще протестировать и автоматизировать больше действий на OneScript

# Инициализация рабочего каталога и создание каталогов
Контекст: 
    # Дано я включаю отладку лога с именем "bdd.tests"
    Допустим Я создаю временный каталог и сохраняю его в контекст
    И Я устанавливаю временный каталог как рабочий каталог

    И Я создаю каталог "folder0/folder01" в рабочем каталоге
    И Я создаю каталог "folder011" в подкаталоге "folder0/folder01" рабочего каталога

    Допустим Я создаю файл "folder0/file01.txt" в рабочем каталоге

    Дано Я создаю временный каталог и сохраняю его в переменной "СпециальныйКаталог"

Сценарий: Создание каталогов
    Тогда В рабочем каталоге существует каталог "folder0/folder01"
    И В подкаталоге "folder0/folder01" рабочего каталога существует каталог "folder011"
    И В подкаталоге "folder0/folder01" рабочего каталога существует каталог "*011"

Сценарий: Создание каталогов с использованием переменных

    Когда Я создаю каталог "СпециальныйКаталог/folder0/folder01"
    Тогда Каталог "СпециальныйКаталог/folder0" существует
    Тогда Каталог "СпециальныйКаталог/folder0/folder01" существует
    И Каталог "СпециальныйКаталог/folder0/folder01-unknown" не существует

    Когда Я создаю каталог "folder1/folder11" внутри каталога "СпециальныйКаталог"
    Тогда Каталог "СпециальныйКаталог/folder1/folder11" существует

    Тогда Каталог "folder0" внутри каталога "СпециальныйКаталог" существует
    И Каталог "folder0/folder01" внутри каталога "СпециальныйКаталог" существует
    И Каталог "folder0/folder01-unknown" внутри каталога "СпециальныйКаталог" не существует

Сценарий: Создание файлов
    Когда Я создаю файл "folder0/file01.txt" в рабочем каталоге
    И Я создаю файл "file01" в подкаталоге "folder0/folder01" рабочего каталога
    Тогда В рабочем каталоге существует файл "folder0/file01.txt"
    И В подкаталоге "folder0/folder01" рабочего каталога существует файл "file01"
    Тогда В рабочем каталоге существует файл "folder0/*01.txt"
    И В подкаталоге "folder0/folder01" рабочего каталога существует файл "*01"

Сценарий: Создание файлов с использованием переменных

    И Я создаю каталог "СпециальныйКаталог/folder0/folder01"
    И Я создаю каталог "folder1/folder11" внутри каталога "СпециальныйКаталог"

    Когда Я создаю файл "СпециальныйКаталог/file01.txt"
    Тогда Файл "СпециальныйКаталог/file01.txt" существует
    И Файл "folder01/file01-unknown.txt" не существует
    
    Когда Я создаю файл "folder1/file11.txt" внутри каталога "СпециальныйКаталог"
    Тогда Файл "СпециальныйКаталог/folder1/file11.txt" существует
    
    И Файл "file01.txt" внутри каталога "СпециальныйКаталог" существует
    И Файл "folder1/file11.txt" внутри каталога "СпециальныйКаталог" существует
    И Файл "folder1/file01-unknown.txt" внутри каталога "СпециальныйКаталог" не существует

Сценарий: Копирование файлов
    Когда Я копирую файл "step_definitions/БезПараметров.os" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я копирую файл "fixtures/test-report.xml" из каталога "tests" проекта в подкаталог "folder0/folder01" рабочего каталога

    Тогда В рабочем каталоге существует файл "БезПараметров.os"
    И В подкаталоге "folder0/folder01" рабочего каталога существует файл "test-report.xml"

Сценарий: Копирование каталогов
    Когда Я копирую каталог "fixtures/step_definitions" из каталога "tests/fixtures" проекта в рабочий каталог
    И Я копирую каталог "fixtures/step_definitions" из каталога "tests" проекта в подкаталог "folder0/folder01" рабочего каталога
    
    Тогда В рабочем каталоге существует каталог "step_definitions"
    И В подкаталоге "folder0/folder01" рабочего каталога существует каталог "step_definitions"

Сценарий: Удаление каталога
    Дано Я создаю каталог "СпециальныйКаталог/КаталогДляУдаления"
    Когда Я удаляю каталог "СпециальныйКаталог/КаталогДляУдаления"
    Тогда Каталог "СпециальныйКаталог/КаталогДляУдаления" не существует

Сценарий: Удаление файла
    Дано Я создаю файл "СпециальныйКаталог/ФайлДляУдаления.txt"
    Когда Я удаляю файл "СпециальныйКаталог/ФайлДляУдаления.txt"
    Тогда Файл "СпециальныйКаталог/ФайлДляУдаления.txt" не существует

Сценарий: Управление стеком текущих каталогов
    Когда Я создаю файл "folder0/file01.txt" в рабочем каталоге
    И Я установил рабочий каталог как текущий каталог
    И Я показываю текущий каталог
    И Я установил подкаталог "folder0" рабочего каталога как текущий каталог

    Тогда Каталог "folder01" существует
    И Каталог "folder0/folder01" не существует
    И Файл "file01.txt" существует
    И Файл "folder0/file01.txt" не существует

    Тогда Каталог "*01" существует
    И Каталог "folder0/*01" не существует
    И Файл "*01.txt" существует
    И Файл "folder0/*01.txt" не существует

    И Я восстановил предыдущий каталог
    И Я восстановил предыдущий каталог

Сценарий: Каталог проекта
    Когда Я сохраняю каталог проекта в контекст
    Тогда Я показываю каталог проекта
    И Я показываю рабочий каталог

Сценарий: Анализ текста файлов в рабочем каталоге
    Тогда Файл "folder0/file01.txt" в рабочем каталоге содержит "Текст файла"
    И Файл "folder0/file01.txt" в рабочем каталоге не содержит "Не существующий текст"
    
Сценарий: Анализ текста файлов в текущем каталоге
    Когда Я установил рабочий каталог как текущий каталог
    Тогда Файл "folder0/file01.txt" содержит "Текст файла"
    И Файл "folder0/file01.txt" не содержит "Не существующий текст"
    И я удаляю файл "folder0/file01.txt"
    И Файл "folder0/file01.txt" не существует